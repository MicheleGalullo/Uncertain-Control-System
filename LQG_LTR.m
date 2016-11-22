% LQG/LTR

clear
close all

model_building

Gu = Greal(3);

% augment system


gaina = 0.25;             
numa = [1.7 0.047 1];
dena = conv([0.001 1],[0.1 1]);
au = gaina*tf(numa,dena);


G1 = series(au,Gu);

% parameter for Filter and Controller


Qf = 1;
Rf = 1;

R = 1;
Q = zeros(size(G1.NominalValue.a)); 
% prendo come errore di controllo le posizioni delle 2 massette
Q(2:5,2:5) = [0.5 0 0 0;0 0.5 0  0;0 0 0 0;0 0 0 0];

% open on input

Kc = lqr(G1.NominalValue,Q,R);

q = [1e3,1e4,1e5,1e6,1.5e7];

dtm = ss(G1.NominalValue.a,G1.NominalValue.b,Kc,0);

figure
nyquist(dtm,'k-.'), hold

[Ks_lqg,SVL, W1] = ltrsyn(G1.NominalValue,Kc,Qf,Rf,q);

% robust analysis

Ga = series(Ks_lqg,G1);
clp = feedback(Ga,1);

[stabmarg, destabunc, sreport, sinfo] = robuststab(clp);
disp(sreport)

disp(' ')

[perfmarg, wcu, preport, pinfo] = robustperf(clp);
disp(preport)

% sensitivity and complementary sensitivity function

loop = loopsens(G1, Ks_lqg);

figure
bodemag(loop.Si.NominalValue,'r',loop.Ti.NominalValue,'b', omega), grid
legend('S','T')
title('sensitivity and complementary sensitivity function')

% test for nominal plant

i = 1;
figure
for pulsazione = 0.5:0.1:1
    sim('lqg_test',50)
    subplot(3,2,i)
    plot(time.Data,d.Data,'b--')
    hold on
    plot(time.Data,yt.Data,'r--')
    title(['disturbo a frequenza ', num2str(pulsazione)])
    ylabel('ampiezza'),xlabel('tempo') 
    hold off
    i=i+1;
end
clear i

opt = bodeoptions;
opt.MagUnits = 'abs';

figure
bodemag(sinfo.MussvBnds(:,1),'b',sinfo.MussvBnds(:,2),'r',omega, opt)
legend('Upper Bound','Lower Bound')
title('mu-analysis stability')

figure
bodemag(pinfo.MussvBnds(:,1),'b',pinfo.MussvBnds(:,2),'r',omega,opt)
legend('Upper Bound','Lower Bound')
title('mu-analysis performance')