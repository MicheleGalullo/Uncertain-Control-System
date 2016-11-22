Ks_mu_rid = hankelmr(Ks_mu, 10);

M_rid = lft(T,Ks_mu_rid);

disp('Robustezza controllore ridotto')
disp(' ')

[stabmarg,destabunc,sreport,sinfo] = robuststab(M_rid);
disp(sreport)

disp(' ')

[perfmarg,wcu,preport,pinfo] = robustperf(M_rid);
disp(preport)

Ks_mu = Ks_mu_rid;

i = 1;
figure
for pulsazione = 0.5:0.1:1
    sim('mu_test',80)
    subplot(3,2,i)
    plot(time.Data,d.Data,'b--')
    hold on
    plot(time.Data,yt.Data,'r--')
    title(['disturbo a frequenza ', num2str(pulsazione) '(rid)'])
    ylabel('ampiezza'),xlabel('tempo') 
    hold off
    i=i+1;
end
clear i

figure
bodemag(sinfo.MussvBnds(:,1),'b',sinfo.MussvBnds(:,2),'r', omega, opt)
legend('Upper Bound','Lower Bound')
title('mu-analysis stability (rid)')

figure
bodemag(sinfo.MussvBnds(:,1),'b',sinfo.MussvBnds(:,2),'r',omega, opt)
legend('Upper Bound','Lower Bound')
title('mu-analysis performance (rid)')