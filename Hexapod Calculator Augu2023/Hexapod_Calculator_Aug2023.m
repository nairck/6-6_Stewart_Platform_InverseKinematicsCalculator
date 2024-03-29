% Filename: stew.m
% Author: Joe Brown, California State University, Sacramento  8/04/2006
% Modified by Adam Johnson, August 2022
% Description: This file contains a function to carry out GUI operation of the closed form forward kinematics analysis program for the 6-DOF CDSL Stewart platform.

function stewsolve(fcn)
clc
if nargin == 0
    fcn = 'stew';
end
switch fcn

    case 'stew'%this is the initial case, which is the figure set up and initialization of all the GUI elements.

        plotinfo.myname = mfilename;
        %--------------------------------------------------------------Main Window
        fig = figure('Position',centerfig(720,710),...
            'Resize','off',...
            'NumberTitle','off',...
            'Name','6-6 Stewart Platform Inverse Kinematics Solver',...
            'Interruptible','off',...
            'Menubar','none',...
            'Color',get(0,'DefaultUIControlBackgroundColor'));
        %------------------------------------------------------------------Axes
        plotinfo.ax = axes('Units','pixels',...
            'Position',[340 62 350 350],...
            'Visible','off');
        %-----------------------------------------------------------Entry Boxes
        %----------Base coordinates
        %uicontrol(gcf,'Style','text','String','joint','Position',[15,588,30,12]);
        uicontrol(gcf,'Style','text','String','xsi','Position',[80,585,20,12]);
        uicontrol(gcf,'Style','text','String','ysi','Position',[155,585,20,12]);
        uicontrol(gcf,'Style','text','String','Zero-Displacement Configuration  [mm]','Position',[-6,685,250,18],'FontWeight','bold','FontSize',8,'ForegroundColor','#00008b');
        uicontrol(gcf,'Style','text','String','Workspace Constraints','Position',[465,655-25,250,18],'FontWeight','bold','FontSize',8,'ForegroundColor','#00008b');

        uicontrol(gcf,'Style','text','String','Base Z Coordinate:','Position',[28,661,100,13]);
        plotinfo.baseZ=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[128,602+55,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        uicontrol(gcf,'Style','text','String','Platform Z Coordinate:','Position',[10,637,120,13]);
        plotinfo.platZheight=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[128,632,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        uicontrol(gcf,'Style','text','String','ZPD Leg Length:','Position',[24,612,120,13]);
        plotinfo.zpdLegLength=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[128,607,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);

        uicontrol(gcf,'Style','text','String','Bench Top Thickness:','Position',[236,661,150,13]);
        plotinfo.benchThickness=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[369,632+25,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' misc']);
        uicontrol(gcf,'Style','text','String','Platform Plane to Benchbottom:','Position',[210,637,160,13]);
        plotinfo.platToBenchBottomZ=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[369,632,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' misc']);
        uicontrol(gcf,'Style','text','String','Focus to Benchtop Z:','Position',[236,612,150,13]);
        plotinfo.benchZheight=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[369,607,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' misc']);

        uicontrol(gcf,'Style','text','String','Base 1:','Position',[5,567,50,12]);
        plotinfo.base1x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,560,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        plotinfo.base1y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[130,560,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        uicontrol(gcf,'Style','text','String','Base 2:','Position',[5,542,50,12]);
        plotinfo.base2x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,535,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        plotinfo.base2y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[130,535,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        uicontrol(gcf,'Style','text','String','Base 3:','Position',[5,517,50,12]);
        plotinfo.base3x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,510,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        plotinfo.base3y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[130,510,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        uicontrol(gcf,'Style','text','String','Base 4:','Position',[5,492,50,12]);
        plotinfo.base4x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,485,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        plotinfo.base4y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[130,485,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        uicontrol(gcf,'Style','text','String','Base 5:','Position',[5,467,50,12]);
        plotinfo.base5x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,460,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        plotinfo.base5y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[130,460,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        uicontrol(gcf,'Style','text','String','Base 6:','Position',[5,442,50,12]);
        plotinfo.base6x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,435,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);
        plotinfo.base6y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[130,435,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' base']);


        %---------------platform coordinates
        uicontrol(gcf,'Style','text','String','xmi','Position',[312,585,20,12]);
        uicontrol(gcf,'Style','text','String','ymi','Position',[382,585,20,12]);
        uicontrol(gcf,'Style','text','String','Platform 1:','Position',[225,567,60,12]);
        plotinfo.plat1x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[285,560,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        plotinfo.plat1y=uicontrol(gcf,'Style','edit', ...cont
            'Position',[359,560,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        uicontrol(gcf,'Style','text','String','Platform 2:','Position',[225,542,60,12]);
        plotinfo.plat2x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[285,535,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        plotinfo.plat2y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[359,535,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        uicontrol(gcf,'Style','text','String','Platform 3:','Position',[225,517,60,12]);
        plotinfo.plat3x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[285,510,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        plotinfo.plat3y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[359,510,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        uicontrol(gcf,'Style','text','String','Platform 4:','Position',[225,492,60,12]);
        plotinfo.plat4x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[285,485,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        plotinfo.plat4y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[359,485,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        uicontrol(gcf,'Style','text','String','Platform 5:','Position',[225,467,60,12]);
        plotinfo.plat5x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[285,460,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        plotinfo.plat5y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[359,460,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        uicontrol(gcf,'Style','text','String','Platform 6:','Position',[225,442,60,12]);
        plotinfo.plat6x=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[285,435,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);
        plotinfo.plat6y=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[359,435,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' plat']);

        %---------------Constraints
        uicontrol(gcf,'Style','text','String','Constraints','Position',[455,579,130,18],'FontWeight','bold','FontSize',8,'ForegroundColor','#A2142F');
        uicontrol(gcf,'Style','text','String','min','Position',[585,585,20,12]);
        uicontrol(gcf,'Style','text','String','max','Position',[655,585,25,12]);
        uicontrol(gcf,'Style','text','String','Roll [° about x]:','Position',[475,563,85,13]);
        plotinfo.rollmin=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[560,560,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        plotinfo.rollmax=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[634,560,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        uicontrol(gcf,'Style','text','String','Pitch [° about y]:','Position',[475,543,85,13]);
        plotinfo.pitchmin=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[560,538,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        plotinfo.pitchmax=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[634,538,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        uicontrol(gcf,'Style','text','String','Yaw [° about z]:','Position',[474,521,85,13]);
        plotinfo.yawmin=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[560,516,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        plotinfo.yawmax=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[634,516,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        uicontrol(gcf,'Style','text','String','X [mm]:','Position',[495,499,50,13]);
        plotinfo.pxmin=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[560,494,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        plotinfo.pxmax=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[634,494,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        uicontrol(gcf,'Style','text','String','Y [mm]:','Position',[495,478,50,13]);
        plotinfo.pymin=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[560,472,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        plotinfo.pymax=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[634,472,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        uicontrol(gcf,'Style','text','String','Z [mm]:','Position',[495,455,50,13]);
        plotinfo.pzmin=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[560,450,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        plotinfo.pzmax=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[634,450,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' constraints']);
        uicontrol(gcf,'Style','text','String','Leg Length [mm]:','Position',[467,433,100,13]);
        plotinfo.jointmin=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[560,428,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' misc']);
        plotinfo.jointmax=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[634,428,70,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' misc']);

        %% %-------------------Leg lengths
        uicontrol(gcf,'Style','text','String','Outputs - Prismatic Leg Lengths [mm]:','Position',[0,402,260,20],'FontWeight','bold','FontSize',10,'ForegroundColor','#00008b');
        uicontrol(gcf,'Style','text','String','old','Position',[60,385,50,15]);
        uicontrol(gcf,'Style','text','String','new','Position',[123,385,50,15]);
        uicontrol(gcf,'Style','text','String','abs. delta','Position',[184,385,50,15]);
        uicontrol(gcf,'Style','text','String','rel. delta','Position',[246,385,50,15]);
                uicontrol(gcf,'Style','text','String','ang. delta [°]','Position',[298,385,70,15]);
        uicontrol(gcf,'Style','text','String','Leg 1:','Position',[5,368,50,15],'FontWeight','bold','FontSize',9,'ForegroundColor','#0072BD');
        plotinfo.leg1_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,365,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'off');
        plotinfo.leg1=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,365,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' legs'], ...
            'enable', 'inactive');
        plotinfo.leg1absdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[179,365,60,20],...
            'enable', 'inactive');
        plotinfo.leg1delta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[241,365,60,20],...
            'enable', 'inactive');
        plotinfo.leg1angledelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[1,1,.9], ...
            'Position',[303,365,60,20],...
            'enable', 'inactive');

        uicontrol(gcf,'Style','text','String','Leg 2:','Position',[5,342,50,15],'FontWeight','bold','FontSize',9,'ForegroundColor','#D95319');
        plotinfo.leg2_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,340,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'off');
        plotinfo.leg2=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,340,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' legs'], ...
            'enable', 'inactive');
        plotinfo.leg2absdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[179,340,60,20],...
            'enable', 'inactive');
        plotinfo.leg2delta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[241,340,60,20],...
            'enable', 'inactive');
        plotinfo.leg2angledelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...            
            'BackgroundColor',[1,1,.9], ...
            'Position',[303,340,60,20],...
            'enable', 'inactive');

        uicontrol(gcf,'Style','text','String','Leg 3:','Position',[5,318,50,15],'FontWeight','bold','FontSize',9,'ForegroundColor','#EDB120');
        plotinfo.leg3_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,315,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'off');
        plotinfo.leg3=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,315,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'inactive');
        plotinfo.leg3absdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[179,315,60,20],...
            'enable', 'inactive');
        plotinfo.leg3delta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[241,315,60,20],...
            'enable', 'inactive');
        plotinfo.leg3angledelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[1,1,.9], ...
            'Position',[303,315,60,20],...
            'enable', 'inactive');

        uicontrol(gcf,'Style','text','String','Leg 4:','Position',[5,293,50,15],'FontWeight','bold','FontSize',9,'ForegroundColor','#7E2F8E');
        plotinfo.leg4_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,290,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'off');
        plotinfo.leg4=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[117,290,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'inactive');
        plotinfo.leg4absdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[179,290,60,20],...
            'enable', 'inactive');
        plotinfo.leg4delta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[241,290,60,20],...
            'enable', 'inactive');
        plotinfo.leg4angledelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[1,1,.9], ...
            'Position',[303,290,60,20],...
            'enable', 'inactive');

        uicontrol(gcf,'Style','text','String','Leg 5:','Position',[5,268,50,15],'FontWeight','bold','FontSize',9,'ForegroundColor','#77AC30');
        plotinfo.leg5_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,265,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'off');
        plotinfo.leg5=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,265,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'inactive');
        plotinfo.leg5absdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[179,265,60,20],...
            'enable', 'inactive');
        plotinfo.leg5delta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[241,265,60,20],...
            'enable', 'inactive');
        plotinfo.leg5angledelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[1,1,.9], ...
            'Position',[303,265,60,20],...
            'enable', 'inactive');

        uicontrol(gcf,'Style','text','String','Leg 6:','Position',[5,243,50,15],'FontWeight','bold','FontSize',9,'ForegroundColor','#4DBEEE');
        plotinfo.leg6_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,240,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'off');
        plotinfo.leg6=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,240,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' legs'],...
            'enable', 'inactive');
        plotinfo.leg6absdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[179,240,60,20],...
            'enable', 'inactive');
        plotinfo.leg6delta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[.8,1,1], ...
            'Position',[241,240,60,20],...
            'enable', 'inactive');
        plotinfo.leg6angledelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'BackgroundColor',[1,1,.9], ...
            'Position',[303,240,60,20],...
            'enable', 'inactive');



        %% %-------------------Angles and position of point of interest (input focus)
        uicontrol(gcf,'Style','text','String','Inputs - Change to Input Focus Posture:','Position',[-2,211,270,15],'FontWeight','bold','FontSize',10,'ForegroundColor','#00008b');
        uicontrol(gcf,'Style','text','String','old','Position',[60,190,50,15]);
        uicontrol(gcf,'Style','text','String','new','Position',[123,190,50,15]);
        uicontrol(gcf,'Style','text','String','rel. delta','Position',[184,190,50,15]);
        uicontrol(gcf,'Style','text','String','Roll [°]:','Position',[5,175,50,13]);
        plotinfo.roll_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,170,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.roll=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,170,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.rolldelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[179,170,60,20],...
            'enable', 'on');
        uicontrol(gcf,'Style','text','String','Pitch [°]:','Position',[5,150,50,13]);
        plotinfo.pitch_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,145,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.pitch=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,145,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.pitchdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[179,145,60,20],...
            'enable', 'on');
        uicontrol(gcf,'Style','text','String','Yaw [°]:','Position',[5,125,50,13]);
        plotinfo.yaw_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,120,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.yaw=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,120,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.yawdelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[179,120,60,20],...
            'enable', 'on');
        uicontrol(gcf,'Style','text','String','X [mm]:','Position',[5,100,50,13]);
        plotinfo.Pxval_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,95,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.Pxval=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,95,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.Pxvaldelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[179,95,60,20],...
            'enable', 'on');
        uicontrol(gcf,'Style','text','String','Y [mm]:','Position',[5,75,50,13]);
        plotinfo.Pyval_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,70,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.Pyval=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,70,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.Pyvaldelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[179,70,60,20],...
            'enable', 'on');
        uicontrol(gcf,'Style','text','String','Z [mm]:','Position',[5,50,50,13]);
        plotinfo.Pzval_old=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[55,45,60,20],...
            'BackgroundColor',[1,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.Pzval=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[117,45,60,20],...
            'BackgroundColor',[.8,1,1], ...
            'CallBack',[plotinfo.myname,' tablepos'],...
            'enable', 'off');
        plotinfo.Pzvaldelta=uicontrol(gcf,'Style','edit', ...
            'String','0',...
            'Position',[179,45,60,20],...
            'enable', 'on');

        %------------------------------------------------------------Quit button
        uicontrol('Style','pushbutton',...
            'Position',[610,10,100,25],...
            'String','Quit',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' quit']);

        %-------------------------------------------------------save configuration button
        plotinfo.save_me=uicontrol('Style','pushbutton',...
            'Position',[247,10,100,25],...
            'String','Save Everything',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' save_me']);

        %------------------------------------------------------- draw orientation workspace button
        plotinfo.workspace_me=uicontrol('Style','pushbutton',...
            'Position',[354,10,150,25],...
            'String','Draw Orientation Workspace',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' workspace_me']);

        %------------------------------------------------------- draw reachable workspace button
        plotinfo.reachable_workspace_me=uicontrol('Style','pushbutton',...
            'Position',[354,37,150,25],...
            'String','Draw Reachable Workspace',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' reachable_workspace_me']);

        %-------------------------------------------------------overwrite old posture button
        plotinfo.overwrite_me=uicontrol('Style','pushbutton',...
            'Position',[247,37,100,25],...
            'String','Update Old Posture',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' overwrite_me']);

        %-------------------------------------------------------zero  button
        plotinfo.zero_me=uicontrol('Style','pushbutton',...
            'Position',[247,64,100,25],...
            'String','Zero Input Values',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' zero_me']);
        %-------------------------------------------------------Solve Forward
        %     plotinfo.sol_for=uicontrol('Style','pushbutton',...
        %         'Position',[45,220,85,25],...
        %         'String','Solve Forward',...
        %         'Interruptible','off',...
        %         'BusyAction','cancel',...
        %         'Callback',[plotinfo.myname,' solve_for']);
        %-------------------------------------------------------Solve Inverse
        plotinfo.sol_inv=uicontrol('Style','pushbutton',...
            'Position',[54,10,186,25],...
            'String','Solve Inverse Kinematics',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' solve_inv']);
        %         %-------------------------------------------------------solution buttons
        plotinfo.prevsol=uicontrol('Style','pushbutton',...
            'Position',[450,50,25,20],...
            'String','<<',...
            'Visible','off',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' prevsol']);
        plotinfo.solutions_text=uicontrol(gcf,'Style','text','String',' ','Position',[482,50,70,15],'Visible','off');
        plotinfo.nextsol=uicontrol('Style','pushbutton',...
            'Position',[560,50,25,20],...
            'String','>>',...
            'Visible','off',...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' nextsol']);
        %-------------------------------------------------animate select button
        plotinfo.animate_but=uicontrol(gcf,'Style','checkbox', ...
            'String','Animate?',...
            'Value',1,...
            'Position',[630,40,70,20]);
        %------------------------------------------------- Edit Zero-Displacement Coordinates
        plotinfo.editzpd_but=uicontrol(gcf,'Style','togglebutton', ...
            'String','Edit Zero-Displacement Coordinates',...
            'Value',0,...
            'Position',[240,685,200,20], ...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' editzpd']);
        %-------------------------------------------------Edit Constraints select button
        plotinfo.editConstraints_but=uicontrol(gcf,'Style','togglebutton', ...
            'String','Edit Workspace Constraints',...
            'Value',0,...
            'Position',[475,606,230,20],...
            'Interruptible','off',...
            'BusyAction','cancel',...
            'Callback',[plotinfo.myname,' editConstraints']);
        %-------------------------------------------save data in window data area
        set(fig,'UserData',plotinfo);
        %----------------------Load data from txt file
        load_data()
        %----------------------draw intial plot
        %zeroDisplacementHeight = -263.8997;
        initial_coords=[str2double(get(plotinfo.plat1x,'String')),str2double(get(plotinfo.plat1y,'String')),str2double(get(plotinfo.platZheight,'String'))-str2double(get(plotinfo.Pzval,'String')),...
            str2double(get(plotinfo.plat2x,'String')),str2double(get(plotinfo.plat2y,'String')),str2double(get(plotinfo.platZheight,'String'))-str2double(get(plotinfo.Pzval,'String')),...
            str2double(get(plotinfo.plat3x,'String')),str2double(get(plotinfo.plat3y,'String')),str2double(get(plotinfo.platZheight,'String'))-str2double(get(plotinfo.Pzval,'String')),...
            str2double(get(plotinfo.plat4x,'String')),str2double(get(plotinfo.plat4y,'String')),str2double(get(plotinfo.platZheight,'String'))-str2double(get(plotinfo.Pzval,'String')),...
            str2double(get(plotinfo.plat5x,'String')),str2double(get(plotinfo.plat5y,'String')),str2double(get(plotinfo.platZheight,'String'))-str2double(get(plotinfo.Pzval,'String')),...
            str2double(get(plotinfo.plat6x,'String')),str2double(get(plotinfo.plat6y,'String')),str2double(get(plotinfo.platZheight,'String'))-str2double(get(plotinfo.Pzval,'String'))];
        draw_plat(initial_coords)
        view([-30,20])
        edit_zpd()
        edit_Constraints()
        color_input_box()

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Callbacks  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %     case 'solve_for'
        %         plotinfo=get(gcf,'UserData');
        %         color_input_box(1);
        %         set(plotinfo.sol_for,'String','Working...');
        %         pause(1)
        %         solve_forward();
        %         set(plotinfo.sol_for,'String','Solve Forward');

    case 'solve_inv'
        plotinfo=get(gcf,'UserData');
        %color_input_box(2);
        set(plotinfo.prevsol,'Visible','off')
        set(plotinfo.nextsol,'Visible','off')
        set(plotinfo.solutions_text,'Visible','off')
        set(plotinfo.sol_inv,'String','Working...');
        %pause(1)
        solve_inverse();
        color_input_box()
        set(plotinfo.sol_inv,'String','Solve Inverse Kinematics');

    case 'base'
        %disp('base')
    case 'plat'
        %disp('plat')
    case 'legs'
        %color_input_box(1)
        %disp('legs')
    case 'constraints'
        %disp('constraints')
    case 'tablepos'
        %color_input_box(2)
        %disp('tablepos')
    case 'editzpd'
        edit_zpd()
    case 'editConstraints'
        edit_Constraints()
    case 'save_me'
        save_data()
        disp('configuration saved...')
    case 'workspace_me'
        draw_orientation_workspace()
    case 'reachable_workspace_me'
        draw_reachable_workspace()
    case 'overwrite_me'
        overwrite_data()
        disp('configuration overwritten and saved...')
    case 'zero_me'
        zero_data()
        disp('new input data zeroed...')
    case 'quit'
        fig = gcf;
        quit_reply = questdlg('Do you want to save and quit (Yes), or quit without saving (No)?');
        if strcmp(quit_reply,'Yes')
            save_data()
            close(fig);
            disp('Configuration saved and quit...')
        elseif strcmp(quit_reply,'No')
            close(fig);
            disp('application quit without saving...')
        end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    FUNCTIONS    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function draw_reachable_workspace
fprintf('working on reachable workspace...\n')
% load("ReachableAndOrientationWorkspaceHighResolution.mat")
tStart = tic;
plotinfo=get(gcf,'UserData');
xsi=[str2double(get(plotinfo.base1x,'String')),...
    str2double(get(plotinfo.base2x,'String')),...
    str2double(get(plotinfo.base3x,'String')),...
    str2double(get(plotinfo.base4x,'String')),...
    str2double(get(plotinfo.base5x,'String')),...
    str2double(get(plotinfo.base6x,'String'))];
ysi=[str2double(get(plotinfo.base1y,'String')),...
    str2double(get(plotinfo.base2y,'String')),...
    str2double(get(plotinfo.base3y,'String')),...
    str2double(get(plotinfo.base4y,'String')),...
    str2double(get(plotinfo.base5y,'String')),...
    str2double(get(plotinfo.base6y,'String'))];
xmi=[str2double(get(plotinfo.plat1x,'String')),...
    str2double(get(plotinfo.plat2x,'String')),...
    str2double(get(plotinfo.plat3x,'String')),...
    str2double(get(plotinfo.plat4x,'String')),...
    str2double(get(plotinfo.plat5x,'String')),...
    str2double(get(plotinfo.plat6x,'String'))];
ymi=[str2double(get(plotinfo.plat1y,'String')),...
    str2double(get(plotinfo.plat2y,'String')),...
    str2double(get(plotinfo.plat3y,'String')),...
    str2double(get(plotinfo.plat4y,'String')),...
    str2double(get(plotinfo.plat5y,'String')),...
    str2double(get(plotinfo.plat6y,'String'))];
baseZ=str2double(get(plotinfo.baseZ,'String'));
platformZ=str2double(get(plotinfo.platZheight,'String'));
w_x_u_temp = zeros(1,100000000);
w_y_u_temp = zeros(1,100000000);
w_z_u_temp = zeros(1,100000000);
w_x_u = zeros(1,100000000);
w_y_u = zeros(1,100000000);
w_z_u = zeros(1,100000000);
w_x_d = zeros(1,100000000);
w_y_d = zeros(1,100000000);
w_z_d = zeros(1,100000000);
roll = 0;
pitch = 0;
yaw = 0;
n = 2;
p = 1;
n_x = 1;
n_y = 1;
n_z = 1;
firstPointTrigger = false;
Z_zero = 0;
n_x_0 = 1;
n_x_00 = 1;
n_x_1 = 1;
n_z_1 = 1000;
leg_lower_limit = str2double(get(plotinfo.jointmin,'String'));
leg_upper_limit = str2double(get(plotinfo.jointmax,'String'));
i = -19;
while i < 19.25
    if (firstPointTrigger == false)
        i = i + (1/n_x_1);
    elseif (abs(i) < 1.5)
        i = i + (1/n_x_0);
    elseif (abs(i) < .75)
        i = i + (1/n_x_00);
    else
        i = i + (1/n_x);
    end
    fprintf('...working really hard on x %1.3f mm...\n',i);
    for j = -18:1/n_y:18
        for k = -18:1/n_z:18
            px = i;
            py = j;
            pz = k;
            inverse_solution_ws=stew_inverse_ws(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ); %inv_return=[Legs,platcoords,animcoords];
            if (((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit))
                n = n + 1;
                w_x_u_temp(n) = i;
                w_y_u_temp(n) = j;
                w_z_u_temp(n) = k;
                if (((w_z_u_temp(n) > Z_zero) && (w_z_u_temp(n-1) < Z_zero ))  || ...
                        ((w_z_u_temp(n) < Z_zero) && (w_z_u_temp(n-1) > Z_zero ))) && ...
                        (w_z_u_temp(n) < 16.8) && (w_z_u_temp(n) > -15.8)
                    kk_old = w_z_u_temp(n-1);
                    for kk = w_z_u_temp(n-1) : (1/n_z_1) : w_z_u_temp(n-1)+(1/n_z)
                        px = w_x_u_temp(n-1);
                        py = w_y_u_temp(n-1);
                        pz = kk_old;
                        inverse_solution_ws=stew_inverse_ws(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ); %inv_return=[Legs,platcoords,animcoords];
                        if (((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit))
                            w_x_u_temp(n-1) = i;
                            w_y_u_temp(n-1) = j;
                            w_z_u_temp(n-1) = kk_old;
                        else
                            continue
                        end
                        kk_old = kk;
                    end
                    kk_old_u = w_z_u_temp(n);
                    px = w_x_u_temp(n);
                    py = w_y_u_temp(n);
                    for kk = w_z_u_temp(n) : -(1/n_z_1) : w_z_u_temp(n)-(1/n_z)
                        pz = kk_old_u;
                        inverse_solution_ws=stew_inverse_ws(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ); %inv_return=[Legs,platcoords,animcoords];
                        if (((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit))
                            kk_old_u = kk;
                        else
                            continue
                        end
                    end
                    w_z_u_temp(n) = kk_old_u;
                    fprintf('......found refined z from  %1.3fmm to %1.3fmm  and  %1.3fmm to %1.3fmm ......\n',ceil(kk_old),kk_old,k,kk_old_u);
                    p = p+1;
                    w_x_u(p) = w_x_u_temp(n);
                    w_y_u(p) = w_y_u_temp(n);
                    w_z_u(p) = w_z_u_temp(n);
                    w_x_d(p) = w_x_u_temp(n-1);
                    w_y_d(p) = w_y_u_temp(n-1);
                    w_z_d(p) = w_z_u_temp(n-1);
                end
            else
                if firstPointTrigger == false
                    Z_zero = k;
                    firstPointTrigger = true;
                    fprintf('>>>>> First workspace point found at (X, Y, Z)=(%1.3fmm, %1.3fmm, %1.3fmm)  <<<<< \n',i,j,k);
                end
            end
        end
    end
    tEnd = toc(tStart);
    fprintf('...Elapsed time:  %d minutes  and  %2.3f seconds  ...\n', floor(tEnd/60), rem(tEnd,60));
end
w_x_u(p:end) = [];
w_y_u(p:end) = [];
w_z_u(p:end) = [];
w_x_d(p:end) = [];
w_y_d(p:end) = [];
w_z_d(p:end) = [];
w_x_u(1) = [];
w_y_u(1) = [];
w_z_u(1) = [];
w_x_d(1) = [];
w_y_d(1) = [];
w_z_d(1) = [];
figure(6513515)
hold on
scatter3(w_x_u,w_y_u,w_z_u,'.')
scatter3(w_x_d,w_y_d,w_z_d,'.')
xlin = linspace(min(w_x_u), max(w_x_u), 100);
ylin = linspace(min(w_y_u),max(w_y_u), 100);
[X,Y] = meshgrid(xlin, ylin);
Z = griddata(w_x_u,w_y_u,w_z_u,X,Y,'natural');  % Z = griddata(x,y,z,X,Y,'natural');        % Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
xlind = linspace(min(w_x_d), max(w_x_d), 100);
ylind = linspace(min(w_y_d),max(w_y_d), 100);
[Xd,Yd] = meshgrid(xlind, ylind);
Zd = griddata(w_x_d,w_y_d,w_z_d,Xd,Yd,'natural');  % Z = griddata(x,y,z,X,Y,'natural');        % Z = griddata(x,y,z,X,Y,'cubic');
mesh(Xd,Yd,Zd)
grid on
title("Reachable Workspace")
xlabel("X [mm]")
ylabel("Y [mm]")
zlabel("Z [mm]")
xlim([-20 20])
ylim([-20 20])
zlim([-20 20])
minx = min(min(Xd(:)));
maxx = max(max(X(:)));
miny = min(min(Yd(:)));
maxy = max(max(Y(:)));
minz = min(min(Zd(:)));
maxz = max(max(Z(:)));
minxpos = find(Xd==minx);
minxpos = minxpos(50,1);
maxxpos = find(X==maxx);
maxxpos = maxxpos(50,1);
minypos = find(Yd==miny);
minypos = 4901;%find(Yd==miny);
maxypos = find(Y==maxy);
maxypos = 5000;%find(Y==maxy);
minzpos = find(Zd==minz, 1, 'first');
maxzpos = find(Z==maxz, 1, 'first');
dx = sprintf('X_{min} = %1.3f', minx);
ux = sprintf('X_{max} = %1.3f', maxx);
dy = sprintf('Y_{min} = %1.3f', miny);
uy = sprintf('Y_{max} = %1.3f', maxy);
dz = sprintf('Z_{min} = %1.3f', minz);
uz = sprintf('Z_{max} = %1.3f', maxz);
text(Xd(minxpos)-3, -15, .5, dx);
text(X(maxxpos)+1, 10, .5, ux);
text(-5, Yd(minypos)-2, -5.5, dy);
text(5, Y(maxypos)+2, 5, uy);
text(Xd(minzpos), Yd(minzpos), Zd(minzpos)-2, dz);
text(X(maxzpos)+2, Y(maxzpos), Z(maxzpos)+2, uz);
plot3([0 0],[0 0],[0 19],'-^k','MarkerSize',3,'linewidth',1)
plot3([0 0],[0 19],[0 0],'->k','MarkerSize',3,'linewidth',1)
plot3([0 19],[0 0],[0 0],'->k','MarkerSize',3,'linewidth',1)
disp("complete")
view(45,2.5)
hold off
tEnd = toc(tStart);
fprintf('...Elapsed time:  %d minutes  and  %2.3f seconds  ...\n', floor(tEnd/60), rem(tEnd,60));




function draw_orientation_workspace
%load("ReachableAndOrientationWorkspaceHighResolution.mat")
tStart = tic;
disp('working on orientation workspace...')
tic
plotinfo=get(gcf,'UserData');
xsi=[str2double(get(plotinfo.base1x,'String')),...
    str2double(get(plotinfo.base2x,'String')),...
    str2double(get(plotinfo.base3x,'String')),...
    str2double(get(plotinfo.base4x,'String')),...
    str2double(get(plotinfo.base5x,'String')),...
    str2double(get(plotinfo.base6x,'String'))];
ysi=[str2double(get(plotinfo.base1y,'String')),...
    str2double(get(plotinfo.base2y,'String')),...
    str2double(get(plotinfo.base3y,'String')),...
    str2double(get(plotinfo.base4y,'String')),...
    str2double(get(plotinfo.base5y,'String')),...
    str2double(get(plotinfo.base6y,'String'))];
xmi=[str2double(get(plotinfo.plat1x,'String')),...
    str2double(get(plotinfo.plat2x,'String')),...
    str2double(get(plotinfo.plat3x,'String')),...
    str2double(get(plotinfo.plat4x,'String')),...
    str2double(get(plotinfo.plat5x,'String')),...
    str2double(get(plotinfo.plat6x,'String'))];
ymi=[str2double(get(plotinfo.plat1y,'String')),...
    str2double(get(plotinfo.plat2y,'String')),...
    str2double(get(plotinfo.plat3y,'String')),...
    str2double(get(plotinfo.plat4y,'String')),...
    str2double(get(plotinfo.plat5y,'String')),...
    str2double(get(plotinfo.plat6y,'String'))];
baseZ=str2double(get(plotinfo.baseZ,'String'));
platformZ=str2double(get(plotinfo.platZheight,'String'));
px = 0;
py = 0;
pz = 0;
w_roll_u_temp = zeros(1,100000000);
w_pitch_u_temp = zeros(1,100000000);
w_yaw_u_temp = zeros(1,100000000);
w_roll_u = zeros(1,100000000);
w_pitch_u = zeros(1,100000000);
w_yaw_u = zeros(1,100000000);
w_roll_d = zeros(1,100000000);
w_pitch_d = zeros(1,100000000);
w_yaw_d = zeros(1,100000000);
roll = 0;
pitch = 0;
yaw = 0;
n = 2;
p = 1;
firstPointTrigger = false;
Z_zero = 0;
n_roll = 10;
n_pitch = 10;
n_yaw = 10;
n_roll_0 = 10;
n_roll_00 = 10;
n_roll_1 = 100;
n_yaw_1 = 1000;
leg_lower_limit = str2double(get(plotinfo.jointmin,'String'));
leg_upper_limit = str2double(get(plotinfo.jointmax,'String'));
i = -1.8;
while i < 1.8
    if (firstPointTrigger == false)
        i = i + (1/n_roll_1);
    elseif (abs(i) < 0.25)
        i = i + (1/n_roll_0);
    elseif (abs(i) < 0.05)
        i = i + (1/n_roll_00);
    else
        i = i + (1/n_roll);
    end
    fprintf('...working really hard on x %1.3f mm...\n',i);
    for j = -1.0:1/n_pitch:1.0
        for k = -1.0:1/n_yaw:1.0
            roll = i;
            pitch = j;
            yaw = k;
            inverse_solution_ws=stew_inverse_ws(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ); %inv_return=[Legs,platcoords,animcoords];
            if (((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                    || (((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit))
                n = n + 1;
                w_roll_u_temp(n) = i;
                w_pitch_u_temp(n) = j;
                w_yaw_u_temp(n) = k;
                if (((w_yaw_u_temp(n) > Z_zero) && (w_yaw_u_temp(n-1) < Z_zero ))  || ...
                        ((w_yaw_u_temp(n) < Z_zero) && (w_yaw_u_temp(n-1) > Z_zero ))) && ...
                        (w_yaw_u_temp(n) < 0.9) && (w_yaw_u_temp(n) > -0.9)
                    kk_old = w_yaw_u_temp(n-1);
                    for kk = w_yaw_u_temp(n-1) : (1/n_yaw_1) : w_yaw_u_temp(n-1)+(1/n_yaw)
                        roll = w_roll_u_temp(n-1);
                        pitch = w_pitch_u_temp(n-1);
                        yaw = kk_old;
                        inverse_solution_ws=stew_inverse_ws(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ); %inv_return=[Legs,platcoords,animcoords];
                        if (((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit))
                            w_roll_u_temp(n-1) = i;
                            w_pitch_u_temp(n-1) = j;
                            w_yaw_u_temp(n-1) = kk_old;
                        else
                            continue
                        end
                        kk_old = kk;
                    end
                    kk_old_u = w_yaw_u_temp(n);
                    roll = w_roll_u_temp(n);
                    pitch = w_pitch_u_temp(n);
                    for kk = w_yaw_u_temp(n) : -(1/n_yaw_1) : w_yaw_u_temp(n)-(1/n_yaw)
                        yaw = kk_old_u;
                        inverse_solution_ws=stew_inverse_ws(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ); %inv_return=[Legs,platcoords,animcoords];
                        if (((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(1)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(2)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(3)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(4)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(5)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit)) ...
                                || (((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))>leg_upper_limit) || ((inverse_solution_ws(6)-str2double(get(plotinfo.zpdLegLength,'String')))<leg_lower_limit))
                            kk_old_u = kk;
                        else
                            continue
                        end
                    end
                    w_yaw_u_temp(n) = kk_old_u;
                    fprintf('......found refined yaw from  %1.3f° to %1.3f°  and  %1.3f° to %1.3f° ......\n',round(kk_old,1,TieBreaker="plusinf"),kk_old,k,kk_old_u);
                    p = p+1;
                    w_roll_u(p) = w_roll_u_temp(n);
                    w_pitch_u(p) = w_pitch_u_temp(n);
                    w_yaw_u(p) = w_yaw_u_temp(n);
                    w_roll_d(p) = w_roll_u_temp(n-1);
                    w_pitch_d(p) = w_pitch_u_temp(n-1);
                    w_yaw_d(p) = w_yaw_u_temp(n-1);
                end
            else
                if firstPointTrigger == false
                    Z_zero = 0;
                    firstPointTrigger = true;
                    fprintf('>>>>> First workspace point found at (roll, pitch, yaw)=(%1.3f°, %1.3f°, %1.3f°)  <<<<< \n',i,j,k);
                end
            end
        end
    end
    tEnd = toc(tStart);
    fprintf('...Elapsed time:  %d minutes  and  %2.3f seconds  ...\n', floor(tEnd/60), rem(tEnd,60));
end
w_roll_u(p:end) = [];
w_pitch_u(p:end) = [];
w_yaw_u(p:end) = [];
w_roll_d(p:end) = [];
w_pitch_d(p:end) = [];
w_yaw_d(p:end) = [];
w_roll_u(1) = [];
w_pitch_u(1) = [];
w_yaw_u(1) = [];
w_roll_d(1) = [];
w_pitch_d(1) = [];
w_yaw_d(1) = [];
figure(6513516)
hold on
%scatter3(w_roll_u_temp,w_pitch_u_temp,w_yaw_u_temp,'.')
%scatter3(w_roll_u,w_pitch_u,w_yaw_u,'.')
%scatter3(w_roll_d,w_pitch_d,w_yaw_d,'.')
xlin = linspace(min(w_roll_u), max(w_roll_u), 100);
ylin = linspace(min(w_pitch_u),max(w_pitch_u), 100);
[X,Y] = meshgrid(xlin, ylin);
Z = griddata(w_roll_u,w_pitch_u,w_yaw_u,X,Y,'natural');  % Z = griddata(x,y,z,X,Y,'natural');        % Z = griddata(x,y,z,X,Y,'cubic');
mesh(X,Y,Z)
xlind = linspace(min(w_roll_d), max(w_roll_d), 100);
ylind = linspace(min(w_pitch_d),max(w_pitch_d), 100);
[Xd,Yd] = meshgrid(xlind, ylind);
Zd = griddata(w_roll_d,w_pitch_d,w_yaw_d,Xd,Yd,'natural');  % Z = griddata(x,y,z,X,Y,'natural');        % Z = griddata(x,y,z,X,Y,'cubic');
mesh(Xd,Yd,Zd)
grid on
plot3([0 0],[0 0],[0 1],'-^k','MarkerSize',3,'linewidth',1)
plot3([0 0],[0 1],[0 0],'->k','MarkerSize',3,'linewidth',1)
plot3([0 2],[0 0],[0 0],'->k','MarkerSize',3,'linewidth',1)
title("Orientation Workspace")
xlabel("Roll [°]")
ylabel("Pitch [°]")
zlabel("Yaw [°]")
xlim([-2 2])
ylim([-1.25 1.25])
zlim([-1.25 1.25])
minx = min(Xd(:));
maxx = max(X(:));
miny = min(Yd(:));
maxy = max(Y(:));
minz = min(Zd(:));
maxz = max(Z(:));
minxpos = find(Xd==minx, 1, 'first');
%minxpos = minxpos(50,1);
maxxpos = find(X==maxx, 1, 'first');
%maxxpos = maxxpos(50,1);
minypos = 4901;%find(Yd==miny);
maxypos = 5000;%find(Y==maxy);
minzpos = find(Zd==minz, 1, 'first');
maxzpos = find(Z==maxz, 1, 'first');
dx = sprintf('Roll_{min} = %1.3f', minx);
ux = sprintf('Roll_{max} = %1.3f', maxx);
dy = sprintf('Pitch_{min} = %1.3f', miny);
uy = sprintf('Pitch_{max} = %1.3f', maxy);
dz = sprintf('Yaw_{min} = %1.3f', minz);
uz = sprintf('Yaw_{max} = %1.3f', maxz);
text(X(minxpos)-.2, 0, .1, dx);
text(X(maxxpos)+.1, 0, -.1, ux);
text(-.6, Y(minypos)+0.2, -.05, dy);
text(.3,Y(maxypos)-0.2, .05, uy);
text(X(minzpos), Yd(minzpos), Zd(minzpos)-.2, dz);
text(X(maxzpos), Y(maxzpos), Z(maxzpos)+.2, uz);
disp("complete")
view(10,5)
hold off
toc


%%
function edit_zpd()
plotinfo=get(gcf,'UserData'); %load form data into plotinfo
editzpd_state=get(plotinfo.editzpd_but,'Value');
if editzpd_state==0
    set(plotinfo.baseZ,'enable','off')
    set(plotinfo.base1x,'enable','off')
    set(plotinfo.base1y,'enable','off')
    set(plotinfo.base2x,'enable','off')
    set(plotinfo.base2y,'enable','off')
    set(plotinfo.base3x,'enable','off')
    set(plotinfo.base3y,'enable','off')
    set(plotinfo.base4x,'enable','off')
    set(plotinfo.base4y,'enable','off')
    set(plotinfo.base5x,'enable','off')
    set(plotinfo.base5y,'enable','off')
    set(plotinfo.base6x,'enable','off')
    set(plotinfo.base6y,'enable','off')
    set(plotinfo.platZheight,'enable','off')
    set(plotinfo.plat1x,'enable','off')
    set(plotinfo.plat1y,'enable','off')
    set(plotinfo.plat2x,'enable','off')
    set(plotinfo.plat2y,'enable','off')
    set(plotinfo.plat3x,'enable','off')
    set(plotinfo.plat3y,'enable','off')
    set(plotinfo.plat4x,'enable','off')
    set(plotinfo.plat4y,'enable','off')
    set(plotinfo.plat5x,'enable','off')
    set(plotinfo.plat5y,'enable','off')
    set(plotinfo.plat6x,'enable','off')
    set(plotinfo.plat6y,'enable','off')
    set(plotinfo.benchZheight,'enable','off')
    set(plotinfo.benchThickness,'enable','off')
    set(plotinfo.zpdLegLength,'enable','off')
    set(plotinfo.platToBenchBottomZ,'enable','off')
    set(plotinfo.benchZheight,'String',(str2double(get(plotinfo.platZheight,'String')) + str2double(get(plotinfo.benchThickness,'String')) + str2double(get(plotinfo.platToBenchBottomZ,'String'))));

elseif editzpd_state==1
    set(plotinfo.baseZ,'enable','on')
    set(plotinfo.base1x,'enable','on')
    set(plotinfo.base1y,'enable','on')
    set(plotinfo.base2x,'enable','on')
    set(plotinfo.base2y,'enable','on')
    set(plotinfo.base3x,'enable','on')
    set(plotinfo.base3y,'enable','on')
    set(plotinfo.base4x,'enable','on')
    set(plotinfo.base4y,'enable','on')
    set(plotinfo.base5x,'enable','on')
    set(plotinfo.base5y,'enable','on')
    set(plotinfo.base6x,'enable','on')
    set(plotinfo.base6y,'enable','on')
    set(plotinfo.platZheight,'enable','on')
    set(plotinfo.plat1x,'enable','on')
    set(plotinfo.plat1y,'enable','on')
    set(plotinfo.plat2x,'enable','on')
    set(plotinfo.plat2y,'enable','on')
    set(plotinfo.plat3x,'enable','on')
    set(plotinfo.plat3y,'enable','on')
    set(plotinfo.plat4x,'enable','on')
    set(plotinfo.plat4y,'enable','on')
    set(plotinfo.plat5x,'enable','on')
    set(plotinfo.plat5y,'enable','on')
    set(plotinfo.plat6x,'enable','on')
    set(plotinfo.plat6y,'enable','on')
    set(plotinfo.benchZheight,'enable','off')
    set(plotinfo.zpdLegLength,'enable','on')
    set(plotinfo.platToBenchBottomZ,'enable','on')
    set(plotinfo.benchThickness,'enable','on')
end



function edit_Constraints()
plotinfo=get(gcf,'UserData'); %load form data into plotinfo
editConstraints_state=get(plotinfo.editConstraints_but,'Value');
if editConstraints_state==0
    set(plotinfo.rollmin,'enable','off')
    set(plotinfo.rollmax,'enable','off')
    set(plotinfo.pitchmin,'enable','off')
    set(plotinfo.pitchmax,'enable','off')
    set(plotinfo.yawmin,'enable','off')
    set(plotinfo.yawmax,'enable','off')
    set(plotinfo.pxmin,'enable','off')
    set(plotinfo.pxmax,'enable','off')
    set(plotinfo.pymin,'enable','off')
    set(plotinfo.pymax,'enable','off')
    set(plotinfo.pzmin,'enable','off')
    set(plotinfo.pzmax,'enable','off')
    set(plotinfo.jointmin,'enable','off')
    set(plotinfo.jointmax,'enable','off')
elseif editConstraints_state==1
    set(plotinfo.rollmin,'enable','on')
    set(plotinfo.rollmax,'enable','on')
    set(plotinfo.pitchmin,'enable','on')
    set(plotinfo.pitchmax,'enable','on')
    set(plotinfo.yawmin,'enable','on')
    set(plotinfo.yawmax,'enable','on')
    set(plotinfo.pxmin,'enable','on')
    set(plotinfo.pxmax,'enable','on')
    set(plotinfo.pymin,'enable','on')
    set(plotinfo.pymax,'enable','on')
    set(plotinfo.pzmin,'enable','on')
    set(plotinfo.pzmax,'enable','on')
    set(plotinfo.jointmin,'enable','on')
    set(plotinfo.jointmax,'enable','on')
end



function pos = centerfig(width,height)
screen_s = get(0,'ScreenSize');
pos = [screen_s(3)/2 - width/2, screen_s(4)/2 - height/2, width, height];




function save_data()
plotinfo=get(gcf,'UserData'); %load form data into plotinfo
base=[str2double(get(plotinfo.base1x,'String')) %save all the info for save to file
    str2double(get(plotinfo.base1y,'String'))
    str2double(get(plotinfo.base2x,'String'))
    str2double(get(plotinfo.base2y,'String'))
    str2double(get(plotinfo.base3x,'String'))
    str2double(get(plotinfo.base3y,'String'))
    str2double(get(plotinfo.base4x,'String'))
    str2double(get(plotinfo.base4y,'String'))
    str2double(get(plotinfo.base5x,'String'))
    str2double(get(plotinfo.base5y,'String'))
    str2double(get(plotinfo.base6x,'String'))
    str2double(get(plotinfo.base6y,'String'))
    str2double(get(plotinfo.baseZ,'String'))];
plat=[str2double(get(plotinfo.plat1x,'String'))
    str2double(get(plotinfo.plat1y,'String'))
    str2double(get(plotinfo.plat2x,'String'))
    str2double(get(plotinfo.plat2y,'String'))
    str2double(get(plotinfo.plat3x,'String'))
    str2double(get(plotinfo.plat3y,'String'))
    str2double(get(plotinfo.plat4x,'String'))
    str2double(get(plotinfo.plat4y,'String'))
    str2double(get(plotinfo.plat5x,'String'))
    str2double(get(plotinfo.plat5y,'String'))
    str2double(get(plotinfo.plat6x,'String'))
    str2double(get(plotinfo.plat6y,'String'))
    str2double(get(plotinfo.platZheight,'String'))];
cnst=[str2double(get(plotinfo.rollmin,'String'))
    str2double(get(plotinfo.rollmax,'String'))
    str2double(get(plotinfo.pitchmin,'String'))
    str2double(get(plotinfo.pitchmax,'String'))
    str2double(get(plotinfo.yawmin,'String'))
    str2double(get(plotinfo.yawmax,'String'))
    str2double(get(plotinfo.pxmin,'String'))
    str2double(get(plotinfo.pxmax,'String'))
    str2double(get(plotinfo.pymin,'String'))
    str2double(get(plotinfo.pymax,'String'))
    str2double(get(plotinfo.pzmin,'String'))
    str2double(get(plotinfo.pzmax,'String'))];
legs=[str2double(get(plotinfo.leg1_old,'String'))
    str2double(get(plotinfo.leg2_old,'String'))
    str2double(get(plotinfo.leg3_old,'String'))
    str2double(get(plotinfo.leg4_old,'String'))
    str2double(get(plotinfo.leg5_old,'String'))
    str2double(get(plotinfo.leg6_old,'String'))
    str2double(get(plotinfo.leg1,'String'))
    str2double(get(plotinfo.leg2,'String'))
    str2double(get(plotinfo.leg3,'String'))
    str2double(get(plotinfo.leg4,'String'))
    str2double(get(plotinfo.leg5,'String'))
    str2double(get(plotinfo.leg6,'String'))];
outs=[str2double(get(plotinfo.roll_old,'String'))
    str2double(get(plotinfo.pitch_old,'String'))
    str2double(get(plotinfo.yaw_old,'String'))
    str2double(get(plotinfo.Pxval_old,'String'))
    str2double(get(plotinfo.Pyval_old,'String'))
    str2double(get(plotinfo.Pzval_old,'String'))
    str2double(get(plotinfo.roll,'String'))
    str2double(get(plotinfo.pitch,'String'))
    str2double(get(plotinfo.yaw,'String'))
    str2double(get(plotinfo.Pxval,'String'))
    str2double(get(plotinfo.Pyval,'String'))
    str2double(get(plotinfo.Pzval,'String'))];
misc =[str2double(get(plotinfo.benchZheight,'String'))
    str2double(get(plotinfo.jointmin,'String'))
    str2double(get(plotinfo.jointmax,'String'))
    str2double(get(plotinfo.benchThickness,'String'))
    str2double(get(plotinfo.zpdLegLength,'String'))
    str2double(get(plotinfo.platToBenchBottomZ,'String'))];
save formdata.txt base plat cnst legs outs misc -ascii;%write all this to the file




function zero_data()
plotinfo=get(gcf,'UserData'); %load form data into plotinfo
set(plotinfo.rolldelta,'String','0');
set(plotinfo.pitchdelta,'String','0');
set(plotinfo.yawdelta,'String','0');
set(plotinfo.Pxvaldelta,'String','0');
set(plotinfo.Pyvaldelta,'String','0');
set(plotinfo.Pzvaldelta,'String','0');
color_input_box()




function overwrite_data()
plotinfo=get(gcf,'UserData'); %load form data into plotinfo
% str2double(get(plotinfo.zpdLegLength,'String')) = str2double(get(plotinfo.zpdLegLength,'String'));
set(plotinfo.leg1_old,'String',(str2double(get(plotinfo.leg1,'String'))));
set(plotinfo.leg2_old,'String',(str2double(get(plotinfo.leg2,'String'))));
set(plotinfo.leg3_old,'String',(str2double(get(plotinfo.leg3,'String'))));
set(plotinfo.leg4_old,'String',(str2double(get(plotinfo.leg4,'String'))));
set(plotinfo.leg5_old,'String',(str2double(get(plotinfo.leg5,'String'))));
set(plotinfo.leg6_old,'String',(str2double(get(plotinfo.leg6,'String'))));
set(plotinfo.roll_old,'String',(str2double(get(plotinfo.roll,'String'))));
set(plotinfo.pitch_old,'String',(str2double(get(plotinfo.pitch,'String'))));
set(plotinfo.yaw_old,'String',(str2double(get(plotinfo.yaw,'String'))));
set(plotinfo.Pxval_old,'String',(str2double(get(plotinfo.Pxval,'String'))));
set(plotinfo.Pyval_old,'String',(str2double(get(plotinfo.Pyval,'String'))));
set(plotinfo.Pzval_old,'String',(str2double(get(plotinfo.Pzval,'String'))));
set(plotinfo.leg1delta,'String',(str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.leg1_old,'String'))));
set(plotinfo.leg2delta,'String',(str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.leg2_old,'String'))));
set(plotinfo.leg3delta,'String',(str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.leg3_old,'String'))));
set(plotinfo.leg4delta,'String',(str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.leg4_old,'String'))));
set(plotinfo.leg5delta,'String',(str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.leg5_old,'String'))));
set(plotinfo.leg6delta,'String',(str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.leg6_old,'String'))));
set(plotinfo.leg1absdelta,'String',(str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg2absdelta,'String',(str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg3absdelta,'String',(str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg4absdelta,'String',(str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg5absdelta,'String',(str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg6absdelta,'String',(str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg1angledelta,'String',((str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.leg1_old,'String')))) * 360 / 1.5);
set(plotinfo.leg2angledelta,'String',((str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.leg2_old,'String')))) * 360 / 1.5);
set(plotinfo.leg3angledelta,'String',((str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.leg3_old,'String')))) * 360 / 1.5);
set(plotinfo.leg4angledelta,'String',((str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.leg4_old,'String')))) * 360 / 1.5);
set(plotinfo.leg5angledelta,'String',((str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.leg5_old,'String')))) * 360 / 1.5);
set(plotinfo.leg6angledelta,'String',((str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.leg6_old,'String')))) * 360 / 1.5);
% set(plotinfo.roll,'String',(str2double(get(plotinfo.roll_old,'String')) - str2double(get(plotinfo.roll_old,'String'))));
% set(plotinfo.pitch,'String',(str2double(get(plotinfo.pitch_old,'String')) - str2double(get(plotinfo.pitch_old,'String'))));
% set(plotinfo.yaw,'String',(str2double(get(plotinfo.yaw_old,'String')) - str2double(get(plotinfo.yaw_old,'String'))));
% set(plotinfo.Pxval,'String',(str2double(get(plotinfo.Pxval_old,'String')) - str2double(get(plotinfo.Pxval_old,'String'))));
% set(plotinfo.Pyval,'String',(str2double(get(plotinfo.Pyval_old,'String')) - str2double(get(plotinfo.Pyval_old,'String'))));
% set(plotinfo.Pzval,'String',(str2double(get(plotinfo.Pzval_old,'String')) - str2double(get(plotinfo.Pzval_old,'String'))));
zero_data();

color_input_box()




function load_data()
% str2double(get(plotinfo.zpdLegLength,'String')) = str2double(get(plotinfo.zpdLegLength,'String'));
load formdata.txt
plotinfo=get(gcf,'UserData');
set(plotinfo.base1x,'String',formdata(1))
set(plotinfo.base1y,'String',formdata(2))
set(plotinfo.base2x,'String',formdata(3))
set(plotinfo.base2y,'String',formdata(4))
set(plotinfo.base3x,'String',formdata(5))
set(plotinfo.base3y,'String',formdata(6))
set(plotinfo.base4x,'String',formdata(7))
set(plotinfo.base4y,'String',formdata(8))
set(plotinfo.base5x,'String',formdata(9))
set(plotinfo.base5y,'String',formdata(10))
set(plotinfo.base6x,'String',formdata(11))
set(plotinfo.base6y,'String',formdata(12))
set(plotinfo.baseZ,'String',formdata(13))
set(plotinfo.plat1x,'String',formdata(14))
set(plotinfo.plat1y,'String',formdata(15))
set(plotinfo.plat2x,'String',formdata(16))
set(plotinfo.plat2y,'String',formdata(17))
set(plotinfo.plat3x,'String',formdata(18))
set(plotinfo.plat3y,'String',formdata(19))
set(plotinfo.plat4x,'String',formdata(20))
set(plotinfo.plat4y,'String',formdata(21))
set(plotinfo.plat5x,'String',formdata(22))
set(plotinfo.plat5y,'String',formdata(23))
set(plotinfo.plat6x,'String',formdata(24))
set(plotinfo.plat6y,'String',formdata(25))
set(plotinfo.platZheight,'String',formdata(26))
set(plotinfo.rollmin,'String',formdata(27))
set(plotinfo.rollmax,'String',formdata(28))
set(plotinfo.pitchmin,'String',formdata(29))
set(plotinfo.pitchmax,'String',formdata(30))
set(plotinfo.yawmin,'String',formdata(31))
set(plotinfo.yawmax,'String',formdata(32))
set(plotinfo.pxmin,'String',formdata(33))
set(plotinfo.pxmax,'String',formdata(34))
set(plotinfo.pymin,'String',formdata(35))
set(plotinfo.pymax,'String',formdata(36))
set(plotinfo.pzmin,'String',formdata(37))
set(plotinfo.pzmax,'String',formdata(38))
set(plotinfo.leg1_old,'String',formdata(39))
set(plotinfo.leg2_old,'String',formdata(40))
set(plotinfo.leg3_old,'String',formdata(41))
set(plotinfo.leg4_old,'String',formdata(42))
set(plotinfo.leg5_old,'String',formdata(43))
set(plotinfo.leg6_old,'String',formdata(44))
set(plotinfo.leg1,'String',formdata(45))
set(plotinfo.leg2,'String',formdata(46))
set(plotinfo.leg3,'String',formdata(47))
set(plotinfo.leg4,'String',formdata(48))
set(plotinfo.leg5,'String',formdata(49))
set(plotinfo.leg6,'String',formdata(50))
set(plotinfo.roll_old,'String',formdata(51))
set(plotinfo.pitch_old,'String',formdata(52))
set(plotinfo.yaw_old,'String',formdata(53))
set(plotinfo.Pxval_old,'String',formdata(54))
set(plotinfo.Pyval_old,'String',formdata(55))
set(plotinfo.Pzval_old,'String',formdata(56))

set(plotinfo.roll,'String',formdata(57))
set(plotinfo.pitch,'String',formdata(58))
set(plotinfo.yaw,'String',formdata(59))
set(plotinfo.Pxval,'String',formdata(60))
set(plotinfo.Pyval,'String',formdata(61))
set(plotinfo.Pzval,'String',formdata(62))
if (formdata(51) == formdata(57))
zero_data();
else
set(plotinfo.rolldelta,'String',(str2double(get(plotinfo.roll,'String')) - str2double(get(plotinfo.roll_old,'String'))));
set(plotinfo.pitchdelta,'String',(str2double(get(plotinfo.pitch,'String')) - str2double(get(plotinfo.pitch_old,'String'))));
set(plotinfo.yawdelta,'String',(str2double(get(plotinfo.yaw,'String')) - str2double(get(plotinfo.yaw_old,'String'))));
set(plotinfo.Pxvaldelta,'String',(str2double(get(plotinfo.Pxval,'String')) - str2double(get(plotinfo.Pxval_old,'String'))));
set(plotinfo.Pyvaldelta,'String',(str2double(get(plotinfo.Pyval,'String')) - str2double(get(plotinfo.Pyval_old,'String'))));
set(plotinfo.Pzvaldelta,'String',(str2double(get(plotinfo.Pzval,'String')) - str2double(get(plotinfo.Pzval_old,'String'))));
end
set(plotinfo.benchZheight,'String',formdata(63))
set(plotinfo.jointmin,'String',formdata(64))
set(plotinfo.jointmax,'String',formdata(65))
set(plotinfo.benchThickness,'String',formdata(66))
set(plotinfo.zpdLegLength,'String',formdata(67))
set(plotinfo.platToBenchBottomZ,'String',formdata(68))
set(plotinfo.leg1delta,'String',(str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.leg1_old,'String'))));
set(plotinfo.leg2delta,'String',(str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.leg2_old,'String'))));
set(plotinfo.leg3delta,'String',(str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.leg3_old,'String'))));
set(plotinfo.leg4delta,'String',(str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.leg4_old,'String'))));
set(plotinfo.leg5delta,'String',(str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.leg5_old,'String'))));
set(plotinfo.leg6delta,'String',(str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.leg6_old,'String'))));
set(plotinfo.leg1absdelta,'String',(str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg2absdelta,'String',(str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg3absdelta,'String',(str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg4absdelta,'String',(str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg5absdelta,'String',(str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg6absdelta,'String',(str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg1angledelta,'String',((str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.leg1_old,'String')))) * 360 / 1.5);
set(plotinfo.leg2angledelta,'String',((str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.leg2_old,'String')))) * 360 / 1.5);
set(plotinfo.leg3angledelta,'String',((str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.leg3_old,'String')))) * 360 / 1.5);
set(plotinfo.leg4angledelta,'String',((str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.leg4_old,'String')))) * 360 / 1.5);
set(plotinfo.leg5angledelta,'String',((str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.leg5_old,'String')))) * 360 / 1.5);
set(plotinfo.leg6angledelta,'String',((str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.leg6_old,'String')))) * 360 / 1.5);
set(plotinfo.rolldelta,'String',(str2double(get(plotinfo.roll,'String')) - str2double(get(plotinfo.roll_old,'String'))));
set(plotinfo.pitchdelta,'String',(str2double(get(plotinfo.pitch,'String')) - str2double(get(plotinfo.pitch_old,'String'))));
set(plotinfo.yawdelta,'String',(str2double(get(plotinfo.yaw,'String')) - str2double(get(plotinfo.yaw_old,'String'))));
set(plotinfo.Pxvaldelta,'String',(str2double(get(plotinfo.Pxval,'String')) - str2double(get(plotinfo.Pxval_old,'String'))));
set(plotinfo.Pyvaldelta,'String',(str2double(get(plotinfo.Pyval,'String')) - str2double(get(plotinfo.Pyval_old,'String'))));
set(plotinfo.Pzvaldelta,'String',(str2double(get(plotinfo.Pzval,'String')) - str2double(get(plotinfo.Pzval_old,'String'))));
color_input_box()



function draw_plat(plat_coords)
cla
hold on
axis vis3d
plotinfo=get(gcf,'UserData');
a1=[str2double(get(plotinfo.base1x,'String')); str2double(get(plotinfo.base1y,'String')); str2double(get(plotinfo.baseZ,'String')); 1];
a2=[str2double(get(plotinfo.base2x,'String')); str2double(get(plotinfo.base2y,'String')); str2double(get(plotinfo.baseZ,'String')); 1];
a3=[str2double(get(plotinfo.base3x,'String')); str2double(get(plotinfo.base3y,'String')); str2double(get(plotinfo.baseZ,'String')); 1];
a4=[str2double(get(plotinfo.base4x,'String')); str2double(get(plotinfo.base4y,'String')); str2double(get(plotinfo.baseZ,'String')); 1];
a5=[str2double(get(plotinfo.base5x,'String')); str2double(get(plotinfo.base5y,'String')); str2double(get(plotinfo.baseZ,'String')); 1];
a6=[str2double(get(plotinfo.base6x,'String')); str2double(get(plotinfo.base6y,'String')); str2double(get(plotinfo.baseZ,'String')); 1];
b1=[plat_coords(1); plat_coords(2); plat_coords(3); 1];
b2=[plat_coords(4); plat_coords(5); plat_coords(6); 1];
b3=[plat_coords(7); plat_coords(8); plat_coords(9); 1];
b4=[plat_coords(10); plat_coords(11); plat_coords(12); 1];
b5=[plat_coords(13); plat_coords(14); plat_coords(15); 1];
b6=[plat_coords(16); plat_coords(17); plat_coords(18); 1];
line_size=2;
%neutral point
plot3([0 0],[0 0],[0 str2double(get(plotinfo.benchZheight,'String'))],'-ob','MarkerSize',2,'linewidth',line_size,'Color','#00008b')
plot3([0 0],[0 0],[0 150],'-^k','MarkerSize',3,'linewidth',1)
plot3([0 0],[0 150],[0 0],'->k','MarkerSize',3,'linewidth',1)
plot3([0 150],[0 0],[0 0],'->k','MarkerSize',3,'linewidth',1)
%base
plot3([a2(1) a3(1)],[a2(2) a3(2)],[str2double(get(plotinfo.baseZ,'String')) str2double(get(plotinfo.baseZ,'String'))],'-b','MarkerSize',6,'linewidth',line_size,'Color','#00008b');
plot3([a4(1) a5(1)],[a4(2) a5(2)],[str2double(get(plotinfo.baseZ,'String')) str2double(get(plotinfo.baseZ,'String'))],'-b','MarkerSize',6,'linewidth',line_size,'Color','#00008b');
plot3([a6(1) a1(1)],[a6(2) a1(2)],[str2double(get(plotinfo.baseZ,'String')) str2double(get(plotinfo.baseZ,'String'))],'-b','MarkerSize',6,'linewidth',line_size,'Color','#00008b');
%legs
plotinfo.p1=plot3([a1(1) b1(1)],[a1(2) b1(2)],[a1(3) b1(3)],'-.ok','MarkerSize',3,'linewidth',line_size,'color','#0072BD'); %,'EraseMode','none');
plotinfo.p2=plot3([a2(1) b2(1)],[a2(2) b2(2)],[a2(3) b2(3)],'-ok','MarkerSize',3,'linewidth',line_size,'color','#D95319');
plotinfo.p3=plot3([a3(1) b3(1)],[a3(2) b3(2)],[a3(3) b3(3)],'-ok','MarkerSize',3,'linewidth',line_size,'color','#EDB120');
plotinfo.p4=plot3([a4(1) b4(1)],[a4(2) b4(2)],[a4(3) b4(3)],'-ok','MarkerSize',3,'linewidth',line_size,'color','#7E2F8E');
plotinfo.p5=plot3([a5(1) b5(1)],[a5(2) b5(2)],[a5(3) b5(3)],'-ok','MarkerSize',3,'linewidth',line_size,'color','#77AC30');
plotinfo.p6=plot3([a6(1) b6(1)],[a6(2) b6(2)],[a6(3) b6(3)],'-ok','MarkerSize',3,'linewidth',line_size,'color','#4DBEEE');
%platform
plotinfo.p7=plot3([b1(1) b2(1)],[b1(2) b2(2)],[b1(3) b2(3)],'-r','MarkerSize',3,'linewidth',line_size,'color', '#A2142F');
plotinfo.p8=plot3([b2(1) b3(1)],[b2(2) b3(2)],[b2(3) b3(3)],'-r','MarkerSize',3,'linewidth',line_size,'color', '#A2142F');
plotinfo.p9=plot3([b3(1) b4(1)],[b3(2) b4(2)],[b3(3) b4(3)],'-r','MarkerSize',3,'linewidth',line_size,'color', '#A2142F');
plotinfo.p10=plot3([b4(1) b5(1)],[b4(2) b5(2)],[b4(3) b5(3)],'-r','MarkerSize',3,'linewidth',line_size,'color', '#A2142F');
plotinfo.p11=plot3([b5(1) b6(1)],[b5(2) b6(2)],[b5(3) b6(3)],'-r','MarkerSize',3,'linewidth',line_size,'color', '#A2142F');
plotinfo.p12=plot3([b6(1) b1(1)],[b6(2) b1(2)],[b6(3) b1(3)],'-r','MarkerSize',3,'linewidth',line_size,'color', '#A2142F');
rotate3d
set(gcf,'UserData',plotinfo)
% xlim([-1500 200])
% ylim([-1500 1500])
% zlim([-500 200])

function anim_plat(plat_coords)
plotinfo=get(gcf,'UserData');
p1xold=get(plotinfo.p1,'XData');
p2xold=get(plotinfo.p2,'XData');
p3xold=get(plotinfo.p3,'XData');
p4xold=get(plotinfo.p4,'XData');
p5xold=get(plotinfo.p5,'XData');
p6xold=get(plotinfo.p6,'XData');
p7xold=get(plotinfo.p7,'XData');
p8xold=get(plotinfo.p8,'XData');
p9xold=get(plotinfo.p9,'XData');
p10xold=get(plotinfo.p10,'XData');
p11xold=get(plotinfo.p11,'XData');
p12xold=get(plotinfo.p12,'XData');
p1yold=get(plotinfo.p1,'YData');
p2yold=get(plotinfo.p2,'YData');
p3yold=get(plotinfo.p3,'YData');
p4yold=get(plotinfo.p4,'YData');
p5yold=get(plotinfo.p5,'YData');
p6yold=get(plotinfo.p6,'YData');
p7yold=get(plotinfo.p7,'YData');
p8yold=get(plotinfo.p8,'YData');
p9yold=get(plotinfo.p9,'YData');
p10yold=get(plotinfo.p10,'YData');
p11yold=get(plotinfo.p11,'YData');
p12yold=get(plotinfo.p12,'YData');
p1zold=get(plotinfo.p1,'ZData');
p2zold=get(plotinfo.p2,'ZData');
p3zold=get(plotinfo.p3,'ZData');
p4zold=get(plotinfo.p4,'ZData');
p5zold=get(plotinfo.p5,'ZData');
p6zold=get(plotinfo.p6,'ZData');
p7zold=get(plotinfo.p7,'ZData');
p8zold=get(plotinfo.p8,'ZData');
p9zold=get(plotinfo.p9,'ZData');
p10zold=get(plotinfo.p10,'ZData');
p11zold=get(plotinfo.p11,'ZData');
p12zold=get(plotinfo.p12,'ZData');
n=40;
for i=1:n
    drawnow
    xp1 =[p1xold(1) (p1xold(2)+(plat_coords(1)-p1xold(2))/n*i)];
    yp1 =[p1yold(1) (p1yold(2)+(plat_coords(2)-p1yold(2))/n*i)];
    zp1 =[p1zold(1) (p1zold(2)+(plat_coords(3)-p1zold(2))/n*i)];
    xp2 =[p2xold(1) (p2xold(2)+(plat_coords(4)-p2xold(2))/n*i)];
    yp2 =[p2yold(1) (p2yold(2)+(plat_coords(5)-p2yold(2))/n*i)];
    zp2 =[p2zold(1) (p2zold(2)+(plat_coords(6)-p2zold(2))/n*i)];
    xp3 =[p3xold(1) (p3xold(2)+(plat_coords(7)-p3xold(2))/n*i)];
    yp3 =[p3yold(1) (p3yold(2)+(plat_coords(8)-p3yold(2))/n*i)];
    zp3 =[p3zold(1) (p3zold(2)+(plat_coords(9)-p3zold(2))/n*i)];
    xp4 =[p4xold(1) (p4xold(2)+(plat_coords(10)-p4xold(2))/n*i)];
    yp4 =[p4yold(1) (p4yold(2)+(plat_coords(11)-p4yold(2))/n*i)];
    zp4 =[p4zold(1) (p4zold(2)+(plat_coords(12)-p4zold(2))/n*i)];
    xp5 =[p5xold(1) (p5xold(2)+(plat_coords(13)-p5xold(2))/n*i)];
    yp5 =[p5yold(1) (p5yold(2)+(plat_coords(14)-p5yold(2))/n*i)];
    zp5 =[p5zold(1) (p5zold(2)+(plat_coords(15)-p5zold(2))/n*i)];
    xp6 =[p6xold(1) (p6xold(2)+(plat_coords(16)-p6xold(2))/n*i)];
    yp6 =[p6yold(1) (p6yold(2)+(plat_coords(17)-p6yold(2))/n*i)];
    zp6 =[p6zold(1) (p6zold(2)+(plat_coords(18)-p6zold(2))/n*i)];
    xp7 =[(p7xold(1)+(plat_coords(1)-p7xold(1))/n*i) (p7xold(2)+(plat_coords(4)-p7xold(2))/n*i)];
    yp7 =[(p7yold(1)+(plat_coords(2)-p7yold(1))/n*i) (p7yold(2)+(plat_coords(5)-p7yold(2))/n*i)];
    zp7 =[(p7zold(1)+(plat_coords(3)-p7zold(1))/n*i) (p7zold(2)+(plat_coords(6)-p7zold(2))/n*i)];
    xp8 =[(p8xold(1)+(plat_coords(4)-p8xold(1))/n*i) (p8xold(2)+(plat_coords(7)-p8xold(2))/n*i)];
    yp8 =[(p8yold(1)+(plat_coords(5)-p8yold(1))/n*i) (p8yold(2)+(plat_coords(8)-p8yold(2))/n*i)];
    zp8 =[(p8zold(1)+(plat_coords(6)-p8zold(1))/n*i) (p8zold(2)+(plat_coords(9)-p8zold(2))/n*i)];
    xp9 =[(p9xold(1)+(plat_coords(7)-p9xold(1))/n*i) (p9xold(2)+(plat_coords(10)-p9xold(2))/n*i)];
    yp9 =[(p9yold(1)+(plat_coords(8)-p9yold(1))/n*i) (p9yold(2)+(plat_coords(11)-p9yold(2))/n*i)];
    zp9 =[(p9zold(1)+(plat_coords(9)-p9zold(1))/n*i) (p9zold(2)+(plat_coords(12)-p9zold(2))/n*i)];
    xp10=[(p10xold(1)+(plat_coords(10)-p10xold(1))/n*i) (p10xold(2)+(plat_coords(13)-p10xold(2))/n*i)];
    yp10=[(p10yold(1)+(plat_coords(11)-p10yold(1))/n*i) (p10yold(2)+(plat_coords(14)-p10yold(2))/n*i)];
    zp10=[(p10zold(1)+(plat_coords(12)-p10zold(1))/n*i) (p10zold(2)+(plat_coords(15)-p10zold(2))/n*i)];
    xp11=[(p11xold(1)+(plat_coords(13)-p11xold(1))/n*i) (p11xold(2)+(plat_coords(16)-p11xold(2))/n*i)];
    yp11=[(p11yold(1)+(plat_coords(14)-p11yold(1))/n*i) (p11yold(2)+(plat_coords(17)-p11yold(2))/n*i)];
    zp11=[(p11zold(1)+(plat_coords(15)-p11zold(1))/n*i) (p11zold(2)+(plat_coords(18)-p11zold(2))/n*i)];
    xp12=[(p12xold(1)+(plat_coords(16)-p12xold(1))/n*i) (p12xold(2)+(plat_coords(1)-p12xold(2))/n*i)];
    yp12=[(p12yold(1)+(plat_coords(17)-p12yold(1))/n*i) (p12yold(2)+(plat_coords(2)-p12yold(2))/n*i)];
    zp12=[(p12zold(1)+(plat_coords(18)-p12zold(1))/n*i) (p12zold(2)+(plat_coords(3)-p12zold(2))/n*i)];
    set(plotinfo.p1,'XData',xp1,'YData',yp1,'ZData',zp1)
    set(plotinfo.p2,'XData',xp2,'YData',yp2,'ZData',zp2)
    set(plotinfo.p3,'XData',xp3,'YData',yp3,'ZData',zp3)
    set(plotinfo.p4,'XData',xp4,'YData',yp4,'ZData',zp4)
    set(plotinfo.p5,'XData',xp5,'YData',yp5,'ZData',zp5)
    set(plotinfo.p6,'XData',xp6,'YData',yp6,'ZData',zp6)
    set(plotinfo.p7,'XData',xp7,'YData',yp7,'ZData',zp7)
    set(plotinfo.p8,'XData',xp8,'YData',yp8,'ZData',zp8)
    set(plotinfo.p9,'XData',xp9,'YData',yp9,'ZData',zp9)
    set(plotinfo.p10,'XData',xp10,'YData',yp10,'ZData',zp10)
    set(plotinfo.p11,'XData',xp11,'YData',yp11,'ZData',zp11)
    set(plotinfo.p12,'XData',xp12,'YData',yp12,'ZData',zp12)
end
set(gcf,'UserData',plotinfo)




function color_input_box()
plotinfo=get(gcf,'UserData');
if (str2double(get(plotinfo.leg1absdelta,'String')) < str2double(get(plotinfo.jointmin,'String'))) || (str2double(get(plotinfo.leg1absdelta,'String')) > str2double(get(plotinfo.jointmax,'String')))
    set(plotinfo.leg1absdelta,'ForegroundColor','#FF0000')
else
    set(plotinfo.leg1absdelta,'ForegroundColor','#77AC30')
end
if (str2double(get(plotinfo.leg2absdelta,'String')) < str2double(get(plotinfo.jointmin,'String'))) || (str2double(get(plotinfo.leg2absdelta,'String')) > str2double(get(plotinfo.jointmax,'String')))
    set(plotinfo.leg2absdelta,'ForegroundColor','#FF0000')
else
    set(plotinfo.leg2absdelta,'ForegroundColor','#77AC30')
end
if (str2double(get(plotinfo.leg3absdelta,'String')) < str2double(get(plotinfo.jointmin,'String'))) || (str2double(get(plotinfo.leg3absdelta,'String')) > str2double(get(plotinfo.jointmax,'String')))
    set(plotinfo.leg3absdelta,'ForegroundColor','#FF0000')
else
    set(plotinfo.leg3absdelta,'ForegroundColor','#77AC30')
end
if (str2double(get(plotinfo.leg4absdelta,'String')) < str2double(get(plotinfo.jointmin,'String'))) || (str2double(get(plotinfo.leg4absdelta,'String')) > str2double(get(plotinfo.jointmax,'String')))
    set(plotinfo.leg4absdelta,'ForegroundColor','#FF0000')
else
    set(plotinfo.leg4absdelta,'ForegroundColor','#77AC30')
end
if (str2double(get(plotinfo.leg5absdelta,'String')) < str2double(get(plotinfo.jointmin,'String'))) || (str2double(get(plotinfo.leg5absdelta,'String')) > str2double(get(plotinfo.jointmax,'String')))
    set(plotinfo.leg5absdelta,'ForegroundColor','#FF0000')
else
    set(plotinfo.leg5absdelta,'ForegroundColor','#77AC30')
end
if (str2double(get(plotinfo.leg6absdelta,'String')) < str2double(get(plotinfo.jointmin,'String'))) || (str2double(get(plotinfo.leg6absdelta,'String')) > str2double(get(plotinfo.jointmax,'String')))
    set(plotinfo.leg6absdelta,'ForegroundColor','#FF0000')
else
    set(plotinfo.leg6absdelta,'ForegroundColor','#77AC30')
end




function inverse_solution=solve_inverse()
% str2double(get(plotinfo.zpdLegLength,'String')) = str2double(get(plotinfo.zpdLegLength,'String'));
plotinfo=get(gcf,'UserData');
xsi=[str2double(get(plotinfo.base1x,'String')),...
    str2double(get(plotinfo.base2x,'String')),...
    str2double(get(plotinfo.base3x,'String')),...
    str2double(get(plotinfo.base4x,'String')),...
    str2double(get(plotinfo.base5x,'String')),...
    str2double(get(plotinfo.base6x,'String'))];
ysi=[str2double(get(plotinfo.base1y,'String')),...
    str2double(get(plotinfo.base2y,'String')),...
    str2double(get(plotinfo.base3y,'String')),...
    str2double(get(plotinfo.base4y,'String')),...
    str2double(get(plotinfo.base5y,'String')),...
    str2double(get(plotinfo.base6y,'String'))];
xmi=[str2double(get(plotinfo.plat1x,'String')),...
    str2double(get(plotinfo.plat2x,'String')),...
    str2double(get(plotinfo.plat3x,'String')),...
    str2double(get(plotinfo.plat4x,'String')),...
    str2double(get(plotinfo.plat5x,'String')),...
    str2double(get(plotinfo.plat6x,'String'))];
ymi=[str2double(get(plotinfo.plat1y,'String')),...
    str2double(get(plotinfo.plat2y,'String')),...
    str2double(get(plotinfo.plat3y,'String')),...
    str2double(get(plotinfo.plat4y,'String')),...
    str2double(get(plotinfo.plat5y,'String')),...
    str2double(get(plotinfo.plat6y,'String'))];

roll= str2double(get(plotinfo.roll_old,'String')) + str2double(get(plotinfo.rolldelta,'String'));
pitch= str2double(get(plotinfo.pitch_old,'String')) + str2double(get(plotinfo.pitchdelta,'String'));
yaw= str2double(get(plotinfo.yaw_old,'String')) + str2double(get(plotinfo.yawdelta,'String'));
px= str2double(get(plotinfo.Pxval_old,'String')) + str2double(get(plotinfo.Pxvaldelta,'String'));
py= str2double(get(plotinfo.Pyval_old,'String')) + str2double(get(plotinfo.Pyvaldelta,'String'));
pz= str2double(get(plotinfo.Pzval_old,'String')) + str2double(get(plotinfo.Pzvaldelta,'String'));

baseZ=str2double(get(plotinfo.baseZ,'String'));
platformZ=str2double(get(plotinfo.platZheight,'String'));
inverse_solution=stew_inverse(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ);
set(plotinfo.leg1,'String',double(inverse_solution(1)));
set(plotinfo.leg2,'String',double(inverse_solution(2)));
set(plotinfo.leg3,'String',double(inverse_solution(3)));
set(plotinfo.leg4,'String',double(inverse_solution(4)));
set(plotinfo.leg5,'String',double(inverse_solution(5)));
set(plotinfo.leg6,'String',double(inverse_solution(6)));

set(plotinfo.leg1delta,'String',(str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.leg1_old,'String'))));
set(plotinfo.leg2delta,'String',(str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.leg2_old,'String'))));
set(plotinfo.leg3delta,'String',(str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.leg3_old,'String'))));
set(plotinfo.leg4delta,'String',(str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.leg4_old,'String'))));
set(plotinfo.leg5delta,'String',(str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.leg5_old,'String'))));
set(plotinfo.leg6delta,'String',(str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.leg6_old,'String'))));
set(plotinfo.leg1absdelta,'String',(str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg2absdelta,'String',(str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg3absdelta,'String',(str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg4absdelta,'String',(str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg5absdelta,'String',(str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg6absdelta,'String',(str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.zpdLegLength,'String'))));
set(plotinfo.leg1angledelta,'String',((str2double(get(plotinfo.leg1,'String')) - str2double(get(plotinfo.leg1_old,'String')))) * 360 / 1.5);
set(plotinfo.leg2angledelta,'String',((str2double(get(plotinfo.leg2,'String')) - str2double(get(plotinfo.leg2_old,'String')))) * 360 / 1.5);
set(plotinfo.leg3angledelta,'String',((str2double(get(plotinfo.leg3,'String')) - str2double(get(plotinfo.leg3_old,'String')))) * 360 / 1.5);
set(plotinfo.leg4angledelta,'String',((str2double(get(plotinfo.leg4,'String')) - str2double(get(plotinfo.leg4_old,'String')))) * 360 / 1.5);
set(plotinfo.leg5angledelta,'String',((str2double(get(plotinfo.leg5,'String')) - str2double(get(plotinfo.leg5_old,'String')))) * 360 / 1.5);
set(plotinfo.leg6angledelta,'String',((str2double(get(plotinfo.leg6,'String')) - str2double(get(plotinfo.leg6_old,'String')))) * 360 / 1.5);
set(plotinfo.roll,'String',(str2double(get(plotinfo.rolldelta,'String')) + str2double(get(plotinfo.roll_old,'String'))));
set(plotinfo.pitch,'String',(str2double(get(plotinfo.pitchdelta,'String')) + str2double(get(plotinfo.pitch_old,'String'))));
set(plotinfo.yaw,'String',(str2double(get(plotinfo.yawdelta,'String')) + str2double(get(plotinfo.yaw_old,'String'))));
set(plotinfo.Pxval,'String',(str2double(get(plotinfo.Pxvaldelta,'String')) + str2double(get(plotinfo.Pxval_old,'String'))));
set(plotinfo.Pyval,'String',(str2double(get(plotinfo.Pyvaldelta,'String')) + str2double(get(plotinfo.Pyval_old,'String'))));
set(plotinfo.Pzval,'String',(str2double(get(plotinfo.Pzvaldelta,'String')) + str2double(get(plotinfo.Pzval_old,'String'))));
plat_coords=inverse_solution(25:42);
anim_state=get(plotinfo.animate_but,'Value');
if anim_state==0
    draw_plat(plat_coords)
elseif anim_state==1
    anim_plat(plat_coords)
end
% xlim([-1500 200])
% ylim([-1500 1500])
% zlim([-500 200])

function inv_return=stew_inverse(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ)
digits(15)                           %digit accuracy specification
a1=[xsi(1);ysi(1);baseZ;1];
a2=[xsi(2);ysi(2);baseZ;1];
a3=[xsi(3);ysi(3);baseZ;1];
a4=[xsi(4);ysi(4);baseZ;1];
a5=[xsi(5);ysi(5);baseZ;1];
a6=[xsi(6);ysi(6);baseZ;1];
TXrad=roll*pi/180;                  %convert the roll angle to radians
TYrad=pitch*pi/180;                 %convert the pitch angle to radians
TZrad=yaw*pi/180;                   %convert the yaw angle to radians
%T is the transformation (translation + rotation) matrix from Frame B to Frame N.
T =[cos(TYrad)*cos(TZrad),                                 -cos(TYrad)*sin(TZrad),                                  sin(TYrad),           px;
    sin(TXrad)*sin(TYrad)*cos(TZrad)+cos(TXrad)*sin(TZrad),-sin(TXrad)*sin(TYrad)*sin(TZrad)+cos(TXrad)*cos(TZrad),-sin(TXrad)*cos(TYrad),py;
    -cos(TXrad)*sin(TYrad)*cos(TZrad)+sin(TXrad)*sin(TZrad), cos(TXrad)*sin(TYrad)*sin(TZrad)+sin(TXrad)*cos(TZrad), cos(TXrad)*cos(TYrad),pz;
    0,                                                      0,                                                      0,                    1 ];
%Ta is the transformation matrix that rotates and translates the
%platform to the correct orientation for animation.
Ta =[cos(TYrad)*cos(TZrad),                                 -cos(TYrad)*sin(TZrad),                                  sin(TYrad),           px;
    sin(TXrad)*sin(TYrad)*cos(TZrad)+cos(TXrad)*sin(TZrad),-sin(TXrad)*sin(TYrad)*sin(TZrad)+cos(TXrad)*cos(TZrad),-sin(TXrad)*cos(TYrad),py;
    -cos(TXrad)*sin(TYrad)*cos(TZrad)+sin(TXrad)*sin(TZrad), cos(TXrad)*sin(TYrad)*sin(TZrad)+sin(TXrad)*cos(TZrad), cos(TXrad)*cos(TYrad),pz;
    0,                                                      0,                                                      0,                    1 ];
b1=T*[xmi(1);ymi(1);platformZ;1];   %b# is the coordinates that will be used for calculation
b2=T*[xmi(2);ymi(2);platformZ;1];
b3=T*[xmi(3);ymi(3);platformZ;1];
b4=T*[xmi(4);ymi(4);platformZ;1];
b5=T*[xmi(5);ymi(5);platformZ;1];
b6=T*[xmi(6);ymi(6);platformZ;1];
b1t=Ta*[xmi(1);ymi(1);platformZ;1]; %b#t are the coordinates that will be animated
b2t=Ta*[xmi(2);ymi(2);platformZ;1];
b3t=Ta*[xmi(3);ymi(3);platformZ;1];
b4t=Ta*[xmi(4);ymi(4);platformZ;1];
b5t=Ta*[xmi(5);ymi(5);platformZ;1];
b6t=Ta*[xmi(6);ymi(6);platformZ;1];
L1=sqrt((abs(a1(1)-b1(1)))^2+(abs(a1(2)-b1(2)))^2+(abs(a1(3)-b1(3)))^2); %L=sqrt((ax-bx)^2+(ay-by)^2+(az-bz)^2)
L2=sqrt((abs(a2(1)-b2(1)))^2+(abs(a2(2)-b2(2)))^2+(abs(a2(3)-b2(3)))^2);
L3=sqrt((abs(a3(1)-b3(1)))^2+(abs(a3(2)-b3(2)))^2+(abs(a3(3)-b3(3)))^2);
L4=sqrt((abs(a4(1)-b4(1)))^2+(abs(a4(2)-b4(2)))^2+(abs(a4(3)-b4(3)))^2);
L5=sqrt((abs(a5(1)-b5(1)))^2+(abs(a5(2)-b5(2)))^2+(abs(a5(3)-b5(3)))^2);
L6=sqrt((abs(a6(1)-b6(1)))^2+(abs(a6(2)-b6(2)))^2+(abs(a6(3)-b6(3)))^2);
Legs=[L1,L2,L3,L4,L5,L6];   %leg value return
platcoords=[b1(1),b1(2),b1(3),b2(1),b2(2),b2(3),b3(1),b3(2),b3(3),b4(1),b4(2),b4(3),b5(1),b5(2),b5(3),b6(1),b6(2),b6(3)]; %plat position return
animcoords=[b1t(1),b1t(2),b1t(3),b2t(1),b2t(2),b2t(3),b3t(1),b3t(2),b3t(3),b4t(1),b4t(2),b4t(3),b5t(1),b5t(2),b5t(3),b6t(1),b6t(2),b6t(3)]; %plat position return for animation
inv_return=[Legs,platcoords,animcoords]; %return


function inv_return_ws=stew_inverse_ws(xsi,ysi,xmi,ymi,roll,pitch,yaw,px,py,pz,baseZ,platformZ)
digits(15)                           %digit accuracy specification
a1=[xsi(1);ysi(1);baseZ;1];
a2=[xsi(2);ysi(2);baseZ;1];
a3=[xsi(3);ysi(3);baseZ;1];
a4=[xsi(4);ysi(4);baseZ;1];
a5=[xsi(5);ysi(5);baseZ;1];
a6=[xsi(6);ysi(6);baseZ;1];
TXrad=roll*pi/180;                  %convert the roll angle to radians
TYrad=pitch*pi/180;                 %convert the pitch angle to radians
TZrad=yaw*pi/180;                   %convert the yaw angle to radians
%T is the transformation (translation + rotation) matrix from Frame B to Frame N.
T =[cos(TYrad)*cos(TZrad),                                 -cos(TYrad)*sin(TZrad),                                  sin(TYrad),           px;
    sin(TXrad)*sin(TYrad)*cos(TZrad)+cos(TXrad)*sin(TZrad),-sin(TXrad)*sin(TYrad)*sin(TZrad)+cos(TXrad)*cos(TZrad),-sin(TXrad)*cos(TYrad),py;
    -cos(TXrad)*sin(TYrad)*cos(TZrad)+sin(TXrad)*sin(TZrad), cos(TXrad)*sin(TYrad)*sin(TZrad)+sin(TXrad)*cos(TZrad), cos(TXrad)*cos(TYrad),pz;
    0,                                                      0,                                                      0,                    1 ];
b1=T*[xmi(1);ymi(1);platformZ;1];   %b# is the coordinates that will be used for calculation
b2=T*[xmi(2);ymi(2);platformZ;1];
b3=T*[xmi(3);ymi(3);platformZ;1];
b4=T*[xmi(4);ymi(4);platformZ;1];
b5=T*[xmi(5);ymi(5);platformZ;1];
b6=T*[xmi(6);ymi(6);platformZ;1];
L1=sqrt((abs(a1(1)-b1(1)))^2+(abs(a1(2)-b1(2)))^2+(abs(a1(3)-b1(3)))^2); %L=sqrt((ax-bx)^2+(ay-by)^2+(az-bz)^2)
L2=sqrt((abs(a2(1)-b2(1)))^2+(abs(a2(2)-b2(2)))^2+(abs(a2(3)-b2(3)))^2);
L3=sqrt((abs(a3(1)-b3(1)))^2+(abs(a3(2)-b3(2)))^2+(abs(a3(3)-b3(3)))^2);
L4=sqrt((abs(a4(1)-b4(1)))^2+(abs(a4(2)-b4(2)))^2+(abs(a4(3)-b4(3)))^2);
L5=sqrt((abs(a5(1)-b5(1)))^2+(abs(a5(2)-b5(2)))^2+(abs(a5(3)-b5(3)))^2);
L6=sqrt((abs(a6(1)-b6(1)))^2+(abs(a6(2)-b6(2)))^2+(abs(a6(3)-b6(3)))^2);
Legs=[L1,L2,L3,L4,L5,L6];   %leg value return
inv_return_ws=[Legs]; %return