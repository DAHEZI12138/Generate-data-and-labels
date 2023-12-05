clear all;
setnames = {}; % set names of fatigue data
HeadFilePath = 'E:\eegsignaldata\'

savepaths_0 = strcat(HeadFilePath,'label','data0_mat'); % save the labels

savepaths_1 = strcat(HeadFilePath,'label','data1_mat'); % save the reaction time

savepaths_2 = strcat(HeadFilePath,'label','data2_mat'); % save the global reaction time


for i = 1:62 % load the data
    filepaths = strcat(HeadFilePath,setnames(i,1));
    filepaths = filepaths{1};
    EEG = pop_loadset(setnames(i,1),filepaths);
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 250);
    event = EEG.event;
    EEG = eeg_checkset( EEG );
    newnames = strcat(setnames(i,1),'_dev_on');
    newnames = newnames{1};

    EEG = pop_epoch( EEG, {  '251'  '252'  }, [-3  0], 'newname', newnames, 'epochinfo', 'yes'); % extarct the event data
    pop_saveset( EEG, newnames,'E:\eegsignaldata\dev_on\');
    EEG = eeg_checkset( EEG );

        for j = 1:(length(cat(1,event.init_index))/3)
            time_dot = cat(1,event.init_time);
            RT(i,j) =  time_dot(3*j-1)-time_dot(3*j-2);                             % Reaction time
            if time_dot(3*j-2) <= 90                                                % Determine if subjects are entering a state of fatigue
                global_RT(i,j) = 0;
            else
                window_strat = time_dot(3*j-2) - 90;
                window_strat_location_0 = find(time_dot > window_strat, 1 , 'first');
                if rem(window_strat_location_0+2,3) == 0
                    window_strat_location_1 = (window_strat_location_0+2)/3;
                elseif rem(window_strat_location_0+1,3) == 0
                    window_strat_location_1 = (window_strat_location_0+1)/3;
                else 
                    window_strat_location_1 = window_strat_location_0/3;
                end          
                global_RT(i,j) = mean(RT(i,window_strat_location_1:j));            % Global reaction time
            end
        end
    sorted_RT = sort(RT(i,1:(length(cat(1,event.init_index))/3)));
    sorted_RT_location = ceil(0.05*(length(cat(1,event.init_index))/3)); 
    alter_RT = sorted_RT(sorted_RT_location);                                       % Reaction time when awake
        for k = 1:(length(cat(1,event.init_index))/3)                               % Determine if subjects are entering a state of fatigue
            if RT(i,k) < 1.5 * alter_RT & global_RT(i,k) < 1.5 * alter_RT
                label(i,k) = 1;                                                     % Awake
            elseif RT(i,k) > 2.5 * alter_RT & global_RT(i,k) > 2.5 * alter_RT
                label(i,k) = 2;                                                     % Fatigue
            else 
                label(i,k) = 5;                                                     % Intermediate state
            end
        end
        
    end
save(savepaths_0,'label');
save(savepaths_1,'RT');
save(savepaths_2,'global_RT');
