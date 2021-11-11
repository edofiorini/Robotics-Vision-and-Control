function x = kinematics(dh, q)
    
    T = compute_transformation_matrix(0, dh.dof, dh, q);
    p = T(1:3,4);
    R = T(1:3,1:3);
    
    % Euler angles
    theta = atan2(sqrt(R(1,3)^2+R(2,3)^2), R(3,3));
    psi = atan2(R(3,2), -R(3,1));
    phi = atan2(R(2,3), R(1,3));
    
    x = [p; phi; theta; psi];
    
end

