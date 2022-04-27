clc
clear 

tic

%�������� ������� ���� Constellation, ������������� ����������� ����������� Stalink �� �������
constellation = Constellation('Starlink');

%���������� ��������� ������ ��� ���� �� � ��������� ������
constellation.getInitialState();


for i = 1:length(constellation.groups)
%��� �������� ��������� ����������� ��������� � ��������� ����������
altitudeGroup = constellation.groups{i}.altitude * 1000; % ������� ������ ������ �� �� � �
earthRadius   = constellation.earthRadius;% ������ �����
satCount      = constellation.groups{i}.totalSatCount;% ���������� ��������� � �����������

% ����������� ������������ ���� ������, ��� ������� ����������� ���������� ��������
viewingAngle = findMinViewAngle(altitudeGroup,satCount,earthRadius);

disp(['����������� ��������� � ������� ������ ' num2str(constellation.groups{i}.altitude)...
    ' �� ������������ ������ �������� ��� ���� ������ ' num2str(viewingAngle) ' �������' ]);

end

toc

function viewingAngle = findMinViewAngle(altitude,numberOfSat,earthRadius)
% ������� ��������� ����� ������������ ���� ������ ��� ������� �������,
% ����������� ����������� ������������ ������ ��� ����� ������� �����������
% �����.

% ������� ����������� �����
earthArea = 4*pi*earthRadius^2;

% ��� ����
angleStep = 1.5*pi/180;
% ������ ����� �����
elevationAngleArray = pi/2:-angleStep:0;
%������� ������ �������
centralAngle1  = zeros(length(elevationAngleArray)); % ������ ����������� �����
localArea11 = centralAngle1; % ������ ������������� �������� ��������� ������� ���� ��� ���������� ������� ���
summuryArea1 = centralAngle1; % ������ ����� �������, ����������� ������������ ���������

i=1;
    for elevationAngle = elevationAngleArray
     
         centralAngle1(i) = acos(cos(elevationAngle)/(1+altitude/earthRadius)) - (elevationAngle);
         localArea11(i) = 2*pi*earthRadius^2*(1-cos(centralAngle1(i)));
         summuryArea1(i) = localArea11(i)*numberOfSat;

         if summuryArea1(i)>= earthArea           
             gammaAngle = pi/2+elevationAngle;
             viewingAngle = asin((sin(gammaAngle)*earthRadius)/((altitude+earthRadius)));
             viewingAngle = viewingAngle*180/pi;
             break
         end
     
        i=i+1;
    end
end