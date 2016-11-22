%%%%%%%%%%%%%%%%%%%%
% h_inf controller %
%%%%%%%%%%%%%%%%%%%%

clear
close all
model_building

Gh = Greal(3);      % prendo come ingresso il controllo

% scelgo le funzioni peso
% voglio minimizzare le funzioni T e GS

gain1 = 72;
num1 = [1 1];
den1 = [10000 1];
W1 = gain1*tf(num1,den1);

gain2 = 0.01;
num2 = [10 1];
den2 = [0.001 1];
W2 = gain2*tf(num2,den2); 

gaind = 0.1;
numd = 1;
dend = 1;
Wd = gaind*tf(numd,dend); 
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% building h_inf structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% scelgo come ingresso del disturbo v, per mantenere i vincoli dei ranghi
% delle matrici affinch? possa effettuare la sintesi del controllore Hinf 

systemnames = 'W1 W2 Wd Gh';
inputvar = '[d; v; u]';
outputvar = '[W1; W2; Gh+v]';
input_to_Gh = '[Wd+u]';
input_to_Wd = '[d]';
input_to_W1 = '[Gh+v]';
input_to_W2 = '[u]';
cleanupsysic = 'yes';
T = sysic; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% synthesized h_inf controller %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nmeas = 1;
ncon = 1;
gmin = 0.01;
gmax = 10000;
tol = 0.01;

[Ks_inf, clp, gam] = hinfsyn(T.NominalValue,nmeas,ncon,gmin,gmax,tol);

loop = loopsens(T(3,3),-Ks_inf);

M = lft(T,Ks_inf);
[stabmarg, destabunc, sreport, sinfo] = robuststab(M);
disp(sreport)

disp(' ')

[perfmarg, wcu, preport, pinfo] = robustperf(M);
disp(preport)

% test for nominal plant

i = 1;
figure
for pulsazione = 0.5:0.1:1
    sim('hinf_test',50)
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

figure
bodemag(W1,'r',W2,'b',Wd,'k-.',omega), grid
legend('W1','W2','Wd')
title('Weight function')

opt = bodeoptions;
opt.MagUnits = 'abs';

figure
bodemag(sinfo.MussvBnds(:,1),'b',sinfo.MussvBnds(:,2),'r',omega,opt)
legend('Upper Bound','Lower Bound')
title('mu-analysis stability')

figure
bodemag(pinfo.MussvBnds(:,1),'b',pinfo.MussvBnds(:,2),'r',omega,opt)
legend('Upper Bound','Lower Bound')
title('mu-analysis performance')





















