function [U,V] = undistort_pinhole(k_radial,p_tangental,Principal_point,Focal_length,Uo,Vo)
% undistort pixel coordinates Uo,Vo given the pinhole camera model and the calibrated camera intrinsic parameters:
%   k_radial the 3 radial distortion parameters (k_1, k_2, k_3)  ;   
%   p_tangental the tangental distortion parameters p_1 p_2 ;   
%   Principal_point the intersection of the optical  axis and the image plane at image coordinates u_0, v_0 ;   
%   Focal_length the focal length in units of pixels f_u, f_v ;  
%   Uo,Vo  1, Nx1, 1xN, or MxN distorted image coordinates to undistort.
%
% For comparison, see the rect and undistort_image functions in Prof. Peter I
% Corke's  Machine Vision Toolkit.
% 


    % k = [0.004180016841640, 0.136452931271259, -0.638647134308425]; % radial
    % p = [-0.001666231998527, -0.00008160213039217031]; % tangental
    % Principal_point=    [1.768267919600727e+02, 1.467681514313797e+02];
    u0 = Principal_point(1);
    v0 = Principal_point(2);
    % Focal_length =  [3.229596901156589e+02, 3.238523693059909e+02]
    fpix_u = Focal_length(1);
    fpix_v = Focal_length(2);

    % Convert pixel coordinates to normalized image coordinates.
    % In units of metres with respect to the camera's principal point.
     u = (Uo-u0) / fpix_u;
     v = (Vo-v0) / fpix_v;
    % radial distance of the pixels from the principal point
     r = sqrt( u.^2 + v.^2 );
    % the pixel coordinate errors due to distortion are
    delta_u = u .* (k_radial(1)*r.^2 + k_radial(2)*r.^4 + k_radial(3)*r.^6) + ...
      2*p_tangental(1)*u.*v + p_tangental(2)*(r.^2 + 2*u.^2);
    delta_v = v .* (k_radial(1)*r.^2 + k_radial(2)*r.^4 + k_radial(3)*r.^6) + ...
      p_tangental(1)*(r.^2 + 2*v.^2) + 2*p_tangental(2)*u.*v;
    % undistorted pixel coordinates in metric units are
    ud = u + delta_u;       vd = v + delta_v;
    % convert back to pixel coordinates
     U = ud * fpix_u + u0;
     V = vd * fpix_v + v0;
     %[U,V] = [U_out,V_out] 
end