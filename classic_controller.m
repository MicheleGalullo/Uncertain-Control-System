% controllore classico

clear
close all

model_building


numc = conv([10 1],[0.35 0.01 1]);    % cancellando i poli del sistema aumento al mia robustezza
denc = conv(conv([0.0001 1],[0.0001 1]),[0.0001 1]);   
gainc = 0.9;

% la funzione di trasferimento ? stata definita con l'aiuto di SISOTOOL

Cs = gainc*tf(numc,denc);


Ga = series(Cs,Greal(3));
clp = feedback(Ga,1);

disp('Robustezza controllore')
disp(' ')

[stabmarg, destabunc, sreport, sinfo] = robuststab(clp);
disp(sreport)

disp(' ')

[perfmarg, wcu, preport, pinfo] = robustperf(clp);
disp(preport)

% test for nominal plant

i = 1;
figure
for pulsazione = 0.5:0.1:1
    sim('clas_test1',50)
    subplot(3,2,i)
    plot(time.Data,d.Data,'b')
    hold on
    plot(time.Data,yt.Data,'r--')
    title(['disturbo a frequenza ', num2str(pulsazione)])
    ylabel('ampiezza'),xlabel('tempo') 
    hold off
    i=i+1;
end
clear i


% grafici

loop = loopsens(Greal.NominalValue(3),Cs);

figure
bodemag(loop.PSi,omega), grid
title('GS')

figure
bodemag(loop.Ti,'b',loop.Si,'r',omega),grid
legend('T','S'), title('T e S')

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

