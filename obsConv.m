function SS_obs = obsConv(ss_system)
  % saca las matrices del sistema
  SS_obs = ss_system; # lo hice igual pero luego actualizo los datos
  A_sys = ss_system.A;
  B_sys = ss_system.B;
  C_sys = ss_system.C;
  D_sys = ss_system.D;

  %primero lo convierte en canonicamente controlable y luego aplica las transpuestas
  % Calcula la matriz de controlabilidad
  C_matrix = ctrb(A_sys, B_sys);
  rank_C = rank(C_matrix);

  % Verifica que el sistema sea controlable
  if rank_C == size(A_sys, 1)
    disp('El sistema es controlable');

    % Calcula la matriz de transformación
    T_matrix = C_matrix;
    T_matrix_inv = inv(T_matrix);

    % Realiza la transformación a la forma canónica controlable
    A_ctrl = T_matrix_inv * A_sys * T_matrix;
    B_ctrl = T_matrix_inv * B_sys;
    C_ctrl = C_sys * T_matrix;
    D_ctrl = D_sys;

    % aplica las transpuestas del controlable para obtener las observables
    SS_obs = ss(A_ctrl', C_ctrl',B_ctrl', D_ctrl);

  else
    disp('El sistema no es controlable. Error de conversión');
    SS_obs = [];  % Retorna vacío si el sistema no es controlable no
  end
end



