%Unstructured Uncertaines

delta_input = ultidyn('delta_input',[1 1],'Bound',1.0);
delta_output = ultidyn('delta_output',[1 1],'Bound',1.0);

%ampiezza max dell' attuatore e del sensore
Gact = tf(50,[1 50]);
Gsens = tf(100,[1 100]);

% l' attuatore lo tratto come dinamica trascurata e la inglobo
% in un incertezza moltiplicativa in ingresso;

Wi = Gact-1;

inputUncertain = Wi*delta_input;

inputUncertain.StateName = 'att';
inputUncertain.InputName = 'uc';
inputUncertain.OutputName = 'u';

% il sensore lo tratto come dinamica trascurata e la inglobo
% in un incertezza moltiplicativa in uscita;
Wo = Gsens-1;

outputUncertain = Wo*delta_output;

outputUncertain.StateName = 'sens';
outputUncertain.InputName = 'y';
outputUncertain.OutputName = 'ym';