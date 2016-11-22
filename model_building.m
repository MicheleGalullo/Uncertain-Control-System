% model building

clear
structured_uncertaines
unstructured_uncertaines

omega = logspace(-4,4,100);

disturb = icsignal(1);
control = icsignal(1);

x1 = icsignal(1);
x2 = icsignal(1);
x1dot = icsignal(1);
x2dot = icsignal(1);

M = iconnect;
M.Input = control;
M.Output = x2;
M.Equation{1} = equate(x1,tf(1,[1 0])*x1dot);
M.Equation{2} = equate(x2,tf(1,[1 0])*x2dot);
M.Equation{3} = equate(x1dot,tf(1/m,[1 0])*(-c*(x1dot-x2dot)-k*(x1-x2)+control));
M.Equation{4} = equate(x2dot,tf(1/m,[1 0])*(c*(x1dot-x2dot)+k*(x1-x2)));

G=M.System;
G.InputName = 'control';
G.OutputName = 'pos2';
G.StateName=['pos1'; 'pos2'; 'vel1'; 'vel2'];

% real system building

systemnames = 'inputUncertain G outputUncertain';
inputvar = '[d; v; uc]';
outputvar = '[outputUncertain + G + v]';
input_to_inputUncertain = '[uc]';
input_to_outputUncertain = '[G]';
input_to_G = '[inputUncertain + uc +d]';
cleanupsysic = 'yes';
Greal = sysic; 

% lft decomposition

[P,Delta,Blkstruct,Normunc] = lftdata(Greal);
