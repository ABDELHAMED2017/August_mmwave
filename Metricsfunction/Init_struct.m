function obj = Init_struct()
%just a zero initialization
global N_loop;
obj.V_B = 0;
obj.W_B = 0;
obj.V_RF = 0;
obj.W_RF = 0;
obj.rate = zeros(N_loop,1);
obj.mse = zeros(N_loop,1);
obj.ber = zeros(N_loop,1);
obj.Rate = 0;
obj.Mse = 0;
obj.Ber = 0;
