
%%
%{ 
Scene : /mnt/nixbig/ownCloud/project_code/vrep_QUT_S11/S11_matlab_20180801_002_one_Pioneer.ttt
Produce data for :  camera_extrinsics__generate_path_3D_data_loop_pose_004.m
%}

%%
addpath('/mnt/nixbig/ownCloud/project_code/')
%%
%{
START VREP application and load the scene -  e.g. /mnt/nixbig/ownCloud/project_code/vrep_QUT_S11/S11_matlab_20180918_008_one_Pioneer.ttt
%}
vrep = VREP();

%%
vrep.simstart()

%%
%{
vrep.simstart()

vrep.simstop()
%}
    %  cam_603_vrepcamera = vrep.camera('cam_603_vrepcamera')
cam603sensor = vrep.camera('cam603sensor')
% cam603sensor.getorient
% cam603sensor.getpos
% cam603sensor.getpose

cam603sensor0 = vrep.camera('cam603sensor0')
% cam603sensor0.getorient
% cam603sensor0.getpos
cam603sensor0_pose = cam603sensor0.getorient
cam603sensor0_pose(1:3,4) = cam603sensor0.getpos'

%%

cam606sensor0 = vrep.camera('cam606sensor0')

cam606sensor0_pose_from_getpose = cam606sensor0.getpose

% cam606sensor0_pose = cam606sensor0.getpose  % wrong values?
cam606sensor0_pose = cam606sensor0.getorient
cam606sensor0_pose(1:3,4) = cam606sensor0.getpos'
%%

cam609sensor0 = vrep.camera('cam609sensor0')

cam609sensor0_pose_from_getpose = cam609sensor0.getpose

% cam609sensor0_pose = cam609sensor0.getpose  % wrong values?
cam609sensor0_pose = cam609sensor0.getorient
cam609sensor0_pose(1:3,4) = cam609sensor0.getpos'



%%


%  show that camera pose, used as a transform, takes coordinates in the world coordinate system to the camera's coordinate system
figure; hold on; grid on; axis equal; xyzlabels()
plot3_rows(cam606sensor0_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'm' )  % unit x
plot3_rows(cam606sensor0_pose*[0 1 0 1 ; 0 0 0 1]' , 'm' )  % unit y 
plot3_rows(cam606sensor0_pose*[0 0 1 1 ; 0 0 0 1]' , 'm' )  %% unit z
plot3_rows(cam606sensor0_pose*[ 1 0 0 1 ; 0 1 0 1 ; 0 0 1 1 ]' , 'ms' )
plot3_rows(cam606sensor0_pose*[ 0 0 0 1 ]' , 'bo' )  % origin of units 
plot3_rows([ 0 0 0 ]' , 'bs' )  % origin of world




% camera (rather than vision sensor type) is consistent 
cam606_vrep_camera_handle = vrep.gethandle('cam_606_vrepcamera')
vrep.getorient(cam606_vrep_camera_handle)
vrep.getpos(cam606_vrep_camera_handle)
vrep.getpose(cam606_vrep_camera_handle)

tr_invert(cam603sensor0_pose)
tr_invert(  [ [eye(3) cam606sensor0.getpos'] ; [ 0 0 0 1 ] ]  )
tr_invert(  [ [rotz(pi/2) cam606sensor0.getpos'] ; [ 0 0 0 1 ] ]  )
tr_invert(  [ [rotz(pi) cam606sensor0.getpos'] ; [ 0 0 0 1 ] ]  )

rad2deg(cam603sensor0.getangle)
cam603sensor0.getresolution

%%
%{
START VREP SIMULATION RUN
%}

%%   check that can grab images
fig_handle_603_rgb = figure_named('cam603sensor0.grab')  ;  
im_603 =  cam603sensor0.grab  ;
idisp(im_603)

fig_handle_606_rgb = figure_named('cam606sensor0.grab')  ;  
im_606 =  cam606sensor0.grab  ;
idisp( im_606 )
size(im_606)

%%
figure_named('Colour distribution')
            subplot(1,3,1); histogram(double(im_606(256:258,326:327,1)), 26, 'BinWidth', 10) ;  title('Rgb') ;  xlim([0 255])
            subplot(1,3,2); histogram(double(im_606(256:258,326:327,2)), 26, 'BinWidth', 10) ;  title('rGb') ;  xlim([0 255])
            subplot(1,3,3); histogram(double(im_606(256:258,326:327,3)), 26, 'BinWidth', 10) ;  title('rgB') ;  xlim([0 255])
            
            [red_N,red_EDGES] = histcounts(double(im_606(326:327,256:258,1)), 'BinWidth', 10) 
            [green_N,green_EDGES] = histcounts(double(im_606(326:327,256:258,2)),  'BinWidth', 10) 
            [blue_N,blue_EDGES] = histcounts(double(im_606(326:327,256:258,3)),  'BinWidth', 10)             
grey_hsv.red=60:80 ;  grey_hsv.green=60:80 ; grey_hsv.blue=60:80

            [red_N,red_EDGES] = histcounts(double(im_606(305:305,264:272,1)), 'BinWidth', 10) 
            [green_N,green_EDGES] = histcounts(double(im_606(305:305,264:272,2)),  'BinWidth', 10) 
            [blue_N,blue_EDGES] = histcounts(double(im_606(305:305,264:272,3)),  'BinWidth', 10) 
black_hsv.red=0:50 ;  black_hsv.green=0:50 ; black_hsv.blue=0:50 

            [red_N,red_EDGES] = histcounts(double(im_606(242:246,313:315,1)), 'BinWidth', 10) 
            [green_N,green_EDGES] = histcounts(double(im_606(242:246,313:315,2)),  'BinWidth', 10) 
            [blue_N,blue_EDGES] = histcounts(double(im_606(242:246,313:315,3)),  'BinWidth', 10) 
blue_hsv.red=10:80 ;  blue_hsv.green=0:120; blue_hsv.blue=1:255


grey_ = im_606(:,:,1) >= grey_hsv.red(1) & im_606(:,:,1)<=grey_hsv.red(end) ...
    & im_606(:,:,1) >= grey_hsv.green(1) & im_606(:,:,2)<=grey_hsv.green(end) ...
    & im_606(:,:,1) >= grey_hsv.blue(1) & im_606(:,:,3)<=grey_hsv.blue(end)  ;
grey_eroded = ierode(grey_, ones(2));
figure; idisp(grey_eroded)

black_ = im_606(:,:,1) >= black_hsv.red(1) & im_606(:,:,1)<=black_hsv.red(end) ...
    & im_606(:,:,1) >= black_hsv.green(1) & im_606(:,:,2)<=black_hsv.green(end) ...
    & im_606(:,:,1) >= black_hsv.blue(1) & im_606(:,:,3)<=black_hsv.blue(end)  ;
black_eroded = ierode(black_, ones(2));
figure; idisp(black_eroded)

blue_= im_606(:,:,1) >= blue_hsv.red(1) & im_606(:,:,1)<=blue_hsv.red(end) ...
    & im_606(:,:,1) >= blue_hsv.green(1) & im_606(:,:,2)<=blue_hsv.green(end) ...
    & im_606(:,:,1) >= blue_hsv.blue(1) & im_606(:,:,3)<=blue_hsv.blue(end)  ;
blue_eroded = ierode(blue_, ones(2));
figure; idisp(blue_eroded)

total_eroded = ierode( grey_ + black_ + blue_ , ones(2) )  ;
figure;  idisp(total_eroded)

% that was manual - lets try 10 mins for the automatic
im_606_hsv = rgb2hsv(double(im_606))  ;
figure  ;  idisp(im_606_hsv(300:500,200:300,:))  ;

[N,XEDGES,YEDGES] =  histcounts2(im_606_hsv(300:500,200:300,1),im_606_hsv(300:500,200:300,2))

[h_,s_] = meshgrid(XEDGES(1:end-1),YEDGES(1:end-1))
surf(h_,s_,permute(N, [2,1]))
[ size(h_) size(s_) size(N)  ]
h_(permute(N, [2,1])>=10)  % --> 0 : 0.05  , 0.50:0.65
s_(permute(N, [2,1])>=10)  % --> 0 : 0.50 , 0 : 0.50

hsv_1= im_606_hsv(:,:,1) >=  0.50 & im_606_hsv(:,:,1)<=0.75 ...
    & im_606_hsv(:,:,1) >= 0.00 & im_606_hsv(:,:,2)<=0.55  ;
idisp(hsv_1)

hsv_2= im_606_hsv(:,:,1) >=  0.00 & im_606_hsv(:,:,1)<=0.05 ...
    & im_606_hsv(:,:,1) >= 0.00 & im_606_hsv(:,:,2)<=0.55  ;
idisp(hsv_2)

% none - is per-pixel !  idisp(hsv_1>0.5 & hsv_2>0.5)
idisp(iclose(hsv_1, ones(3))>0.5 & iclose(hsv_2,ones(3))>0.5)
idisp(idilate(hsv_1, ones(3))>0.5 & idilate(hsv_2,ones(3))>0.5)

idisp(idilate(hsv_1, ones(2))>0.5 & idilate(hsv_2,ones(2))>0.5)

by_colour_model_hsv = idilate(hsv_1, ones(2))>0.5 & idilate(hsv_2,ones(2))>0.5   ;

idisp( by_colour_model_hsv )


%% pose -> fustrum intersect floor plane ('FoV'), FoV -> grid, grid -> pixels , count pixels -> is grid free
% get poses from VRep 
%  /mnt/nixbig/ownCloud/project_code/geom__z_plane_intercept.m 
%   see   /mnt/nixbig/ownCloud/project_code/temp__geometric_representation_graph_of_FoV_3d.m

cam_1_3d = cam606sensor0_pose(1:3,4) 

% cam_ = CentralCamera('resolution',[800,600], '')
% cam_.centre

%  see  http://www.forum.coppeliarobotics.com/viewtopic.php?f=9&t=4283
cam603sensor0_angle = double(cam603sensor0.getangle)  ;
cam_res = double(cam603sensor0.getresolution)  ;
cam_res_aspect_ratio = cam_res(1)/cam_res(2) ;
if cam_res(1)>cam_res(2)
    cam603sensor0_angleX = cam603sensor0.getangle  ;
    cam603sensor0_angleY = 2*atan(tan(cam603sensor0_angle/2) / cam_res_aspect_ratio ) ;
else
    cam603sensor0_angleY = cam603sensor0.getangle  ;
    cam603sensor0_angleX = 2*atan(tan(cam603sensor0_angle/2) * cam_res_aspect_ratio ) ;
end
rad2deg( [cam603sensor0_angleX cam603sensor0_angleY ] )


% Stride of 10 gets you 4800 pixel-rays
angle_per_pixel = zeros(ceil(cam_res(1)/10),ceil(cam_res(2)/10),2) ;
size(angle_per_pixel )
for ii_ = 1:10:cam_res(1)
    anglePosX=atan(tan(0.5*cam603sensor0_angleX)*(2*ii_/cam_res(1)-1))  ;
    for jj_ = 1:10:cam_res(2)
        anglePosY=atan(tan(0.5*cam603sensor0_angleY)*(2*jj_/cam_res(2)-1))  ;
        angle_per_pixel(ii_,jj_,:) = [anglePosX,anglePosY]  ;
    end
end

%% 606
cam_res = double(cam606sensor0.getresolution)  ;
cam_res_aspect_ratio = cam_res(1)/cam_res(2) ;
cam606sensor0_angle = double(cam606sensor0.getangle)  ;
if cam_res(1)>cam_res(2)
    cam606sensor0_angleX = cam606sensor0.getangle  ;
    cam606sensor0_angleY = 2*atan(tan(cam606sensor0_angle/2) / cam_res_aspect_ratio ) ;
else
    cam606sensor0_angleY = cam606sensor0.getangle  ;
    cam606sensor0_angleX = 2*atan(tan(cam606sensor0_angle/2) * cam_res_aspect_ratio ) ;
end
angle_per_pixel_corners = zeros(4,2) ;
size(angle_per_pixel_corners )
corner_pixels = [1,1,800,800 ; 1,600,600,1]'
corner_points = zeros(4,3)  ;
adj = 1 ;
for ii_ = 1:4
    anglePosX=atan(tan(0.5*cam606sensor0_angleX)*(2*corner_pixels(ii_,1)/cam_res(1)-1))  ;
    anglePosY=atan(tan(0.5*cam606sensor0_angleY)*(2*corner_pixels(ii_,2)/cam_res(2)-1))  ;
    angle_per_pixel_corners(ii_,:) = [anglePosX,anglePosY]  ;
    
    offset_x = tan(anglePosX) / adj  ;
    offset_y = tan(anglePosY) / adj  ;
    corner_points(ii_,:) = [ adj, offset_x, offset_y ]  ;
end


%%
cam603sensor0_optical_centre = cam603sensor0_pose(1:3,4)  ;
fustrum_corner_points = permute(corner_points,[2 1]) + repmat(cam603sensor0_optical_centre,1,4)  ;
fustrum_corner_points_world = tr_invert(cam603sensor0_pose)*euc2hom( fustrum_corner_points )*cam603sensor0_pose
fustrum_corner_points_world = tr_invert(cam603sensor0_pose)*euc2hom( fustrum_corner_points )
fustrum_corner_points_world = tr_invert(cam603sensor0_pose)*euc2hom( permute(corner_points,[2 1]) )

fustrum_corner_points_world = tr_invert(rpy2tr(+1.5665e+2 , +4.8340e+1 , -4.9700e+1 ,'zyx'))*euc2hom( fustrum_corner_points )
fustrum_corner_points_world = cam603sensor0_pose*euc2hom( permute(corner_points,[2 1]) )
fustrum_corners_world = permute(corner_points,[2 1])+repmat(cam603sensor0_pose(1:3,4),1,4)  ;

figure;  hold on; grid on; axis equal; xyzlabels()
draw_cam_fustrum_3d( fustrum_corners_world , cam603sensor0_optical_centre , 'r')
draw_cam_fustrum_3d( h2e(fustrum_corner_points_world) , cam603sensor0_optical_centre , 'm')
plot3_rows([0;0;0],'bo')

% --- VRep cameras are ZF XL YU  ( LUF ) rather than FLU or RDF --- %

% RPY = TR2RPY(T, options) are the roll-pitch-yaw angles (1x3)
% corresponding to the rotation part of a homogeneous transform T. The 3
% angles RPY=[R,P,Y] correspond to sequential rotations about the X, Y and
% Z axes respectively.

rollZ_pitchX_yawY=tr2rpy(cam606sensor0_pose)  
rad2deg(rollZ_pitchX_yawY)
rollX_pitchY_yawZ = [ rollZ_pitchX_yawY( 3) , rollZ_pitchX_yawY(1) , rollZ_pitchX_yawY(2) ]   ;

rpy2tr(+1.5665e+2 , +4.8340e+1 , -4.9700e+1 ,'zyx')

rollX_pitchY_yawZ_pose_rot = rpy2tr(rollX_pitchY_yawZ)
rollX_pitchY_yawZ_pose = rt2tr( rollX_pitchY_yawZ_pose_rot(1:3,1:3) , cam606sensor0_pose(1:3,4)) 

fustrum_corner_points_world = tr_invert(rollX_pitchY_yawZ_pose )*euc2hom( fustrum_corner_points )
fustrum_corner_points_world = tr_invert(rollX_pitchY_yawZ_pose )*euc2hom( permute(corner_points,[2 1]) )
fustrum_corner_points_world = rollX_pitchY_yawZ_pose *euc2hom( permute(corner_points,[2 1]) ) 
fustrum_corner_points_world = fustrum_corner_points_world +repmat(cam603sensor0_pose(1:4,4),1,4)  ;

figure;  hold on; grid on; axis equal; xyzlabels()
draw_cam_fustrum_3d( fustrum_corners_world , cam603sensor0_optical_centre , 'r')
draw_cam_fustrum_3d( h2e(fustrum_corner_points_world) , cam603sensor0_optical_centre , 'm')
plot3_rows([0;0;0],'bo')


%
dummy_camera_pose = rt2tr( eye(3) , [5;1;2])
dummy_camera_pose = rt2tr(rotz(pi/2),[5;1;2])
dummy_camera_pose_inverse = tr_invert(dummy_camera_pose)
dummy_fustrum_in_world_coords = dummy_camera_pose_inverse*euc2hom(permute( corner_points,[2 1]) )
dummy_fustrum_in_world_coords = dummy_camera_pose_inverse*euc2hom( permute(corner_points,[2 1]) )
figure;  hold on; grid on; axis equal; xyzlabels()
draw_cam_fustrum_3d( h2e(dummy_fustrum_in_world_coords) , cam603sensor0_optical_centre , 'r')
draw_cam_fustrum_3d( fustrum_corners_world , cam603sensor0_optical_centre , 'r')

a_ = dummy_camera_pose*[1 0 0 1]'
b_ = dummy_camera_pose*[0 0 0 1]'
c_ = dummy_camera_pose*[0 0 2 1]'
d_ = dummy_camera_pose*[2 0 2 1]'
plot3_rows([1 0 0 1]','bo')
plot3_rows([0 0 0 1]','bo')
plot3_rows([0 0 2 1]','bo')
plot3_rows([2 0 2 1]','bo')
plot3_rows([5;1;2;1],'rs')
fig_ = gcf
fig_.Name='world coordinates'
figure_named('camera coordinates'); hold on; grid on; axis equal; xyzlabels()
plot3_rows(dummy_camera_pose*[1 0 0 1]','bo')
plot3_rows(dummy_camera_pose*[0 0 0 1]','bo')
plot3_rows(dummy_camera_pose*[0 0 2 1]','bo')
plot3_rows(dummy_camera_pose*[2 0 2 1]','bo')
plot3_rows(dummy_camera_pose*[5;1;2;1],'rs')

figure_named('camera coordinates 2'); hold on; grid on; axis equal; xyzlabels()
plot3_rows(tr_invert(dummy_camera_pose)*[1 0 0 1]','bo')
plot3_rows(tr_invert(dummy_camera_pose)*[0 0 0 1]','bs')
plot3_rows(tr_invert(dummy_camera_pose)*[0 0 2 1]','bd')
plot3_rows(tr_invert(dummy_camera_pose)*[2 0 2 1]','bx')
plot3_rows(tr_invert(dummy_camera_pose)*[5;1;2;1],'rs')

plot3_rows(  h2e([a_,b_] )  )
draw_axes_direct(t2r(dummy_camera_pose),dummy_camera_pose(1:3,4),'',1)




%% 606

cam606sensor0_pose = cam606sensor0.getorient
cam606sensor0_pose(1:3,4) = cam606sensor0.getpos'

% cam606sensor0_pose = cam606sensor0.getpose
cam606sensor0_optical_centre = cam606sensor0_pose(1:3,4)  ;
%  show that camera pose, used as a transform, takes coordinates in the world coordinate system to the camera's coordinate system
figure; hold on; grid on; axis equal; xyzlabels()
plot3_rows(cam606sensor0_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'm' )  % unit x
plot3_rows(cam606sensor0_pose*[0 1 0 1 ; 0 0 0 1]' , 'm' )  % unit y 
plot3_rows(cam606sensor0_pose*[0 0 1 1 ; 0 0 0 1]' , 'm' )  %% unit z
plot3_rows(cam606sensor0_pose*[ 1 0 0 1 ; 0 1 0 1 ; 0 0 1 1 ]' , 'ms' )
plot3_rows(cam606sensor0_pose*[ 0 0 0 1 ]' , 'bo' )  % origin of units 
plot3_rows([ 0 0 0 ]' , 'bs' )  % origin of world


plot3_rows(tr_invert(cam606sensor0_pose)*[ 1 0 0 1 ; 0 0 0 1 ]' , 'm' )  % unit x
plot3_rows(tr_invert(cam606sensor0_pose)*[0 1 0 1 ; 0 0 0 1]' , 'm' )  % unit y 
plot3_rows(tr_invert(cam606sensor0_pose)*[0 0 1 1 ; 0 0 0 1]' , 'm' )  %% unit z
plot3_rows(tr_invert(cam606sensor0_pose)*[ 1 0 0 1 ; 0 1 0 1 ; 0 0 1 1 ]' , 'ms' )
plot3_rows(tr_invert(cam606sensor0_pose)*[ 0 0 0 1 ]' , 'bo' )  % origin of units 

corner_points_in_world = tr_invert(cam606sensor0_pose) * euc2hom(permute(corner_points,[2 1]) )       ;
%corner_points_in_world = cam606sensor0_pose * euc2hom(permute(corner_points,[2 1]) )       

draw_cam_fustrum_3d(  h2e(  corner_points_in_world  ) , cam606sensor0_optical_centre , 'r')     

%%

vrep = VREP()
vrep.simstart()
%%
Camera_test = vrep.camera('Vision_sensor_test')
Camera_test_cuboid_handle =  vrep.gethandle('Camera_test_cuboid')
Camera_test_cuboid = vrep.object('Camera_test_cuboid') 
Camera_test_cuboid.getpose
Camera_test_cuboid.getorient
Camera_test_pose = Camera_test.getpose
figure; hold on; grid on; axis equal; xyzlabels()
plot3_rows(Camera_test_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'm' )  % unit x
plot3_rows(Camera_test_pose*[0 1 0 1 ; 0 0 0 1]' , 'm' )  % unit y 
plot3_rows(Camera_test_pose*[0 0 1 1 ; 0 0 0 1]' , 'm' )  %% unit z
plot3_rows(Camera_test_pose*[ 1 0 0 1 ; 0 1 0 1 ; 0 0 1 1 ]' , 'ms' )
plot3_rows(Camera_test_pose*[ 0 0 0 1 ]' , 'bo' )  % origin of units 
plot3_rows([ 0 0 0 ]' , 'bs' )  % origin of world
    %  position is good, angle is wrong - looks orthogonal
Camera_test_orient_to_pose = Camera_test.getpose
Camera_test_orient = Camera_test.getorient
Camera_test_orient_to_pose(1:3,1:3) = Camera_test_orient(1:3,1:3)
Camera_test_pose
Camera_test_orient_to_pose
plot3_rows(Camera_test_orient_to_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'r' )  % unit x
plot3_rows(Camera_test_orient_to_pose*[0 1 0 1 ; 0 0 0 1]' , 'g' )  % unit y 
plot3_rows(Camera_test_orient_to_pose*[0 0 1 1 ; 0 0 0 1]' , 'b' )  %% unit z
plot3_rows(Camera_test_orient_to_pose*[ 1 0 0 1 ; 0 1 0 1 ; 0 0 1 1 ]' , 'rs' )


rollZ_pitchX_yawY=tr2rpy(Camera_test_orient_to_pose)  
rad2deg(rollZ_pitchX_yawY)
rollX_pitchY_yawZ = [ rollZ_pitchX_yawY( 3) , rollZ_pitchX_yawY(1) , rollZ_pitchX_yawY(2) ]   ;
rollX_pitchY_yawZ_pose_rot = rpy2tr(rollX_pitchY_yawZ)
rollX_pitchY_yawZ_pose = rt2tr( rollX_pitchY_yawZ_pose_rot(1:3,1:3) , Camera_test_orient_to_pose(1:3,4)) 

plot3_rows(rollX_pitchY_yawZ_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'r' )  % unit x
plot3_rows(rollX_pitchY_yawZ_pose*[0 1 0 1 ; 0 0 0 1]' , 'g' )  % unit y 
plot3_rows(rollX_pitchY_yawZ_pose*[0 0 1 1 ; 0 0 0 1]' , 'b' )  %% unit z
plot3_rows(rollX_pitchY_yawZ_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'rd' )  % unit x
plot3_rows(rollX_pitchY_yawZ_pose*[0 1 0 1 ; 0 0 0 1]' , 'gd' )  % unit y 
plot3_rows(rollX_pitchY_yawZ_pose*[0 0 1 1 ; 0 0 0 1]' , 'bd' )  %% unit z

dummy_camera_pose = rt2tr(  roty(deg2rad(-45))*rotz(deg2rad(-45)) , Camera_test_orient_to_pose(1:3,4) )
plot3_rows(rollX_pitchY_yawZ_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'r' )  % unit x
plot3_rows(rollX_pitchY_yawZ_pose*[0 1 0 1 ; 0 0 0 1]' , 'g' )  % unit y 
plot3_rows(rollX_pitchY_yawZ_pose*[0 0 1 1 ; 0 0 0 1]' , 'b' )  %% unit z
plot3_rows(rollX_pitchY_yawZ_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'rx' )  % unit x
plot3_rows(rollX_pitchY_yawZ_pose*[0 1 0 1 ; 0 0 0 1]' , 'gx' )  % unit y 
plot3_rows(rollX_pitchY_yawZ_pose*[0 0 1 1 ; 0 0 0 1]' , 'bx' )  %% unit z


%  I think that this is the right pose for the camera, but I've got myself confused plotting the various vectors
puck_position = [+4.7213e+0;+9.2507e+0;+9.9889e-3] ;
direction_to_look_in = [+4.7213e+0;+9.2507e+0;+9.9889e-3] - Camera_test_orient_to_pose(1:3,4)
desired_up_vector = direction_to_look_in + [0;0;10]
to_puck = coordinate_system_looking_at( direction_to_look_in , desired_up_vector)
plot3_rows([direction_to_look_in [ 0 ; 0 ; Camera_test_orient_to_pose(3,4)] ] ,'k')
plot3_rows([direction_to_look_in [ direction_to_look_in(1:2) ; 0] ] ,'c')
plot3_rows([0;0;0],'bo')
plot3_rows([direction_to_look_in , desired_up_vector],'k')


plot3_rows([direction_to_look_in Camera_test_orient_to_pose(1:3,4) ] ,'c')
plot3_rows([desired_up_vector Camera_test_orient_to_pose(1:3,4) ] )
plot3_rows([desired_up_vector direction_to_look_in ] )

dummy_camera_pose = rt2tr(  to_puck , Camera_test_orient_to_pose(1:3,4) )
plot3_rows(dummy_camera_pose*[ 3 0 0 1 ; 0 0 0 1 ]' , 'r' )  % unit x
plot3_rows(dummy_camera_pose*[0 3 0 1 ; 0 0 0 1]' , 'g' )  % unit y 
plot3_rows(dummy_camera_pose*[0 0 3 1 ; 0 0 0 1]' , 'b' )  %% unit z
plot3_rows(dummy_camera_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'rx' )  % unit x
plot3_rows(dummy_camera_pose*[0 1 0 1 ; 0 0 0 1]' , 'gx' )  % unit y 
plot3_rows(dummy_camera_pose*[0 0 1 1 ; 0 0 0 1]' , 'bx' )  %% unit z
plot3_rows([0;0;0],'bo')
% yes:  looks good for the dummy camera
plot3_rows([Camera_test_orient_to_pose(1:3,4) puck_position] , 'r:' )  % unit x
plot3_rows(puck_position , 'ro' )  % unit x

% 606
puck_position = [ +1.5213e+0 ; +3.3507e+0 ; +9.9996e-3 ] ;
direction_to_look_in = puck_position - cam606sensor0_pose(1:3,4)
desired_up_vector = direction_to_look_in + [0;0;10]
to_puck = coordinate_system_looking_at( direction_to_look_in , desired_up_vector)
calc606_camera_pose = rt2tr(  to_puck , cam606sensor0_pose(1:3,4) )
plot3_rows(calc606_camera_pose*[ 3 0 0 1 ; 0 0 0 1 ]' , 'r' )  % unit x
plot3_rows(calc606_camera_pose*[0 3 0 1 ; 0 0 0 1]' , 'g' )  % unit y 
plot3_rows(calc606_camera_pose*[0 0 3 1 ; 0 0 0 1]' , 'b' )  %% unit z
plot3_rows(calc606_camera_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'rx' )  % unit x
plot3_rows(calc606_camera_pose*[0 1 0 1 ; 0 0 0 1]' , 'gx' )  % unit y 
plot3_rows(calc606_camera_pose*[0 0 1 1 ; 0 0 0 1]' , 'bx' )  %% unit z
plot3_rows([0;0;0],'bo')
plot3_rows([cam606sensor0_pose(1:3,4) puck_position] , 'r:' )  % unit x
plot3_rows(puck_position , 'ro' )  % unit x
% yes:  looks good for the cam606

%603
puck_position =         [ +5.5713e+0 ; +6.4507e+0 ; +9.9996e-3  ] ;
cam_pose = cam603sensor0_pose
% refactor below: setup args above
direction_to_look_in = puck_position - cam_pose(1:3,4)
desired_up_vector = direction_to_look_in + [0;0;10]
to_puck = coordinate_system_looking_at( direction_to_look_in , desired_up_vector)
calculated_camera_pose = rt2tr(  to_puck , cam_pose(1:3,4) )

calculated_camera_pose = rt2tr(  to_puck , cam_pose(1:3,4) )
calculated_camera_pose = rt2tr(  calculated_camera_pose(1:3,1:3)*rotx(deg2rad(10))  ,  cam_pose(1:3,4)  )

calculated_camera_pose = rt2tr(  to_puck , cam_pose(1:3,4) )
calculated_camera_pose = rt2tr(  calculated_camera_pose(1:3,1:3)*rotx(deg2rad(-10))  ,  cam_pose(1:3,4)  )

calculated_camera_pose = rt2tr(  to_puck , cam_pose(1:3,4) )
calculated_camera_pose = rt2tr(  calculated_camera_pose(1:3,1:3)*rotx(deg2rad(-10))*rotz(deg2rad(-10))  ,  cam_pose(1:3,4)  )

calculated_camera_pose = rt2tr(  to_puck , cam_pose(1:3,4) )
calculated_camera_pose = rt2tr(  calculated_camera_pose(1:3,1:3)*( rotx(deg2rad(-10))*rotz(deg2rad(-10)) )  ,  cam_pose(1:3,4)  )

plot3_rows(calculated_camera_pose*[ 3 0 0 1 ; 0 0 0 1 ]' , 'r' )  % unit x
plot3_rows(calculated_camera_pose*[0 3 0 1 ; 0 0 0 1]' , 'g' )  % unit y 
plot3_rows(calculated_camera_pose*[0 0 3 1 ; 0 0 0 1]' , 'b' )  %% unit z
plot3_rows(calculated_camera_pose*[ 1 0 0 1 ; 0 0 0 1 ]' , 'rx' )  % unit x
plot3_rows(calculated_camera_pose*[0 1 0 1 ; 0 0 0 1]' , 'gx' )  % unit y 
plot3_rows(calculated_camera_pose*[0 0 1 1 ; 0 0 0 1]' , 'bx' )  %% unit z
plot3_rows([0;0;0],'bo')
plot3_rows([cam_pose(1:3,4) puck_position] , 'r:' )  % unit x
plot3_rows(puck_position , 'ro' )  % unit x



%%
    cam_to_floor_vec(ii_,:) = cam_1_3d  - cam1_fov_3d(ii_,:)  ;
    [z_plane_intercept_vec__ , ...
        scaling_factor_for_vector_along_line_to_intercept__] ...
        =   geom__z_plane_intercept(  [cam_1_3d(1:2)' ; 0]  ,  cam_to_floor_vec(ii_,:)'  , 1)   ;
    plot3_rows( [cam_1_3d']-z_plane_intercept_vec__, 'bs')

%% FoV -> grid, grid -> pixels  , count pixels -> is grid free


%% grid -> pixels  , count pixels -> is grid free


%%  count pixels -> is grid free




%%    marker detection --> 2D pixel point

idisp(im2bw(im_606))
[label, num_sets] = ilabel(im2bw(im_606))  ;
num_sets
marker_pixels = label==2 ;
idisp(marker_pixels)
blob =  imoments(marker_pixels) 
hold on
plot(blob.uc,blob.vc,'gx')
% 3D point
marker_handle = vrep.gethandle('BoofCV_5_Sphere')
vrep.getpos(marker_handle)

pioneer_handle = vrep.gethandle('Pioneer_p3dx')
class(pioneer_handle)
pioneer_pose = vrep.getpose(pioneer_handle)
pioneer_object = vrep.object('Pioneer_p3dx')
class(pioneer_object)


Pioneer_p3dx_leftMotor_handle = vrep.gethandle('Pioneer_p3dx_leftMotor')  ;
vrep.getjoint(Pioneer_p3dx_leftMotor_handle)
Pioneer_p3dx_rightMotor_handle = vrep.gethandle('Pioneer_p3dx_rightMotor')  ;
vrep.getjoint(Pioneer_p3dx_rightMotor_handle)

vrep.setjointtarget(Pioneer_p3dx_leftMotor_handle,-2.0)
vrep.setjointtarget(Pioneer_p3dx_rightMotor_handle,2.0)

vrep.setjointvel(Pioneer_p3dx_leftMotor_handle,1.0)
vrep.setjointvel(Pioneer_p3dx_rightMotor_handle,-1.0)
vrep.setjointvel(Pioneer_p3dx_rightMotor_handle,1.0)

vrep.setjointvel(Pioneer_p3dx_leftMotor_handle,0.0)
vrep.setjointvel(Pioneer_p3dx_rightMotor_handle,0.0)

vrep.getobjparam_float
vrep.setobjparam_float(pioneer_handle,'left_add_vel',1.0)

way_pts = [
    300.0, 500.0 ; 
    100.0, 500.0 ; 
    120.0, 400.0 ; 
    90.0, 80.0 ; 
    100, 10 ; 
    500.0, 500.0]  ;
class(way_pts)
way_pts = [
    200.0, 200.0 ; 
    100.0, 150.0 ; 
    120.0, 400.0 ; 
    90.0, 80.0 ; 
    100, 10 ; 
    500.0, 500.0]  ;

%{
way_pts = [  ...
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 0 50 ] 
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 100 200 ]
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 150 220 ]
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 200 100 ] 
    pioneer_pose__orig_local(1:2,4)'.*100 + [ 250 120 ]
    pioneer_pose__orig_local(1:2,4)'.*100 ]  ;
way_pts=double(round(way_pts))  ;
class(way_pts)
%}    

pioneer_z_ = pioneer_pose(3,4)
pioneer2_ = pioneer_object
%   pioneer_pose__orig = pioneer_object.getpose
pioneer_pose__orig_local = pioneer_object.getpose


pioneer_object.setpos(single([0 0 0])) ;  pioneer_object.setorient(eye(3))
pioneer_object.setpose( pioneer_pose__orig) ; pioneer_object.setorient(eye(3))
%  [x_old,y_old] = [x,y]
[x,y] = map_to_world(total_path_smoothed__(2,:)',total_path_smoothed__(1,:)') ;
way_pts = [x y].*100  ;
pp = temp__pure_pursuit_vrep_waypoints( ...
    pioneer_z_ , pioneer2_ , ...
    way_pts , vrep ,  pioneer_object )

way_pts

%{  
    RESET THE POSE
    pioneer_object.setpose( pioneer_pose__orig) ; pioneer_object.setorient(eye(3))
    pioneer_object.setpose( pioneer_pose__orig_local) ; pioneer_object.setorient(eye(3))
%}
    global time_stamp
    global detected
    global marker_2D_uv
    global pose_3D
    
    detected_double = double(detected)  ;
    save( strcat('/mnt/nixbig/ownCloud/project_code/mat_files_S11_sim/',datestr(datetime,30),'.mat.txt') , 'time_stamp', 'detected_double', 'marker_2D_uv', 'pose_3D',  '-ascii','-double','-tabs' )
    
    time_stamp = []  ;
    detected = uint32([])  ;
    marker_2D_uv = [0 0 ]  ;
    pose_3D = [ 0 0 0  ]  ;
    
figure_named('pose_3D'); plot3_rows(pose_3D','rx'); hold on; grid on; axis equal; xlabel('x'); ylabel('y')
figure_named('pixels 2D'); plot_rows(marker_2D_uv','rx'); hold on; grid on; axis equal; xlabel('x'); ylabel('y')


    time_stamp_old = time_stamp  ;
    detected_old = detected;
    marker_2D_uv_old = marker_2D_uv  ;
    pose_3D_old = pose_3D  ;