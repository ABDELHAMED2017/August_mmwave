function [obj] = PE_method(obj)
%% transmit
%a = norm(W_opt,'fro'); %for better performance
global V_ropt W_ropt
t1 = clock;
[ V_RF,V_B ] = PE_AltMin( V_ropt );
[ W_RF,W_B ] = PE_AltMin( W_ropt );

V_B = V_B / norm(V_RF*V_B, 'fro') ;

t2 = clock;
runtime  = etime(t2,t1);
obj.runtime = obj.runtime + runtime;
obj.V_B = V_B;
obj.W_B = W_B;
obj.V_RF = V_RF;
obj.W_RF = W_RF;
obj = get_metric(obj);