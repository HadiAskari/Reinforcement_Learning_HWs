states = [];
for playerSum = 12:21
    for dealerCard = 1:10
        for usableAce = 0:1
            states = [states; [playerSum, dealerCard, usableAce]];
        end
    end
end


actions = [0,1];
ind=0;
q = dictionary();
temp=dictionary();
returns = zeros(400,10);

for i = 1:size(states, 1)
    for j = 0:size(actions, 1)
        ind=ind+1;
        q(sprintf('%d %d ',states(i, :), j))=0;
        temp(sprintf('%d %d ',states(i, :), j))=ind;
        %returns=[returns []];
    end
end


policy = dictionary();


for i = 1:size(states, 1)
    policy(sprintf('%d ',states(i, :)))=0;
end





for i = 1:500000
    [q, returns, policy] = run_iteration(states, q, returns, policy,temp);
end







hit_x = [];
hit_y = [];

stick_x = [];
stick_y = [];


for i = 1:length(states)
    state = states(i, :);
    key=sprintf('%d ',states(i, :));

    if state(3) == 1
        if policy(key) == 1
            hit_x = [hit_x; state(2)];
            hit_y = [hit_y; state(1)];
        else
            stick_x = [stick_x; state(2)];
            stick_y = [stick_y; state(1)];
        end

    elseif state(3) == 0
        continue;
    end
end



scatter(hit_x, hit_y, 40,'x', 'red');
hold on;
scatter(stick_x, stick_y, 40, 'blue');

exportgraphics(gca, 'Usable-Soft17Stick-Scatter.pdf', 'Resolution', 400)


clf


hit_x = [];
hit_y = [];

stick_x = [];
stick_y = [];





for i = 1:length(states)
    state = states(i, :);
    key=sprintf('%d ',state);

    if state(3) == 1
        continue;


    elseif state(3) == 0

        if policy(key) == 1
            hit_x = [hit_x; state(2)];
            hit_y = [hit_y; state(1)];
        else
            stick_x = [stick_x; state(2)];
            stick_y = [stick_y; state(1)];
        end
    end
end


scatter(stick_x, stick_y, 40, 'blue');

hold on;

scatter(hit_x, hit_y, 40,'x', 'red');


exportgraphics(gca, 'Unusable-Soft17Stick-Scatter.pdf', 'Resolution', 400)



v_values_usable=[];
v_values_unusable=[];


for i = 1:length(states)
    
        state = states(i, :);

        key1 = sprintf('%d %d ',state, 0);
        key2 = sprintf('%d %d ',state, 1);
        
        mid = [q(key1) q(key2)];

        res=max(mid);

        
    
        if state(3) == 1
            v_values_usable=[v_values_usable; res];
            
        else
            v_values_unusable=[v_values_unusable; res];
        
       
    end
end

v_values_usable(isnan(v_values_usable))=-1;
v_values_unusable(isnan(v_values_unusable))=-1;

for k = 1:numel(v_values_usable)
    C_k = v_values_usable(k);
    C_k(C_k > 1) = 1;
    C_k(C_k<-1)= -1;
    v_values_usable(k) = C_k;
end


for k = 1:numel(v_values_unusable)
    C_k = v_values_unusable(k);
    C_k(C_k > 1) = 1;
    C_k(C_k<-1)= -1;
    v_values_unusable(k) = C_k;
end


states_X_usable=[];

states_Y_usable=[];

states_X_unusable=[];

states_Y_unusable=[];

for i = 1:length(states)
    state = states(i, :);
    key=sprintf('%d ',state);

    if state(3) == 1
        states_X_usable=[states_X_usable; state(2)];
        states_Y_usable=[states_Y_usable; state(1)];


    elseif state(3) == 0
        states_X_unusable=[states_X_unusable; state(2)];
        states_Y_unusable=[states_Y_unusable; state(1)];

       
        end
end





[xq,yq] = meshgrid(1:1:11, 12:1:21);


clf

%contour3(states_X_usable,states_Y_usable,v_values_usable);

vq = griddata(states_X_usable,states_Y_usable,v_values_usable,xq,yq);

mesh(xq,yq,vq)
hold on
plot3(states_X_usable,states_Y_usable,v_values_usable,"o")

exportgraphics(gca, 'Usable-Soft17Stick-Contour.pdf', 'Resolution', 400)
% 
clf
% 
% contour3(states_X_unusable,states_Y_unusable,v_values_unusable);
% 


[xq,yq] = meshgrid(1:1:11, 12:1:21);

%contour3(states_X_usable,states_Y_usable,v_values_usable);

vq = griddata(states_X_unusable,states_Y_unusable,v_values_unusable,xq,yq);

mesh(xq,yq,vq)
hold on
plot3(states_X_usable,states_Y_usable,v_values_usable,"o")

exportgraphics(gca, 'Unusable-Soft17Stick-Contour.pdf', 'Resolution', 400)



clf





function [q, returns, policy] = run_iteration(states, q, returns, policy,temp)
    iteration = [];
    
    % choose random initial state
    state = states(randi(length(states)),:);


    while true
        % choose policy action
        action = policy(sprintf('%d ',state));

        % save to iteratireturnson
        iteration = [iteration; [state, action]];

        if  action == 1
            % draw a card
            card = randi([1,10]);
            pv = card + state(1);
            if pv > 21
                % usable ace, make it unusable
                if state(3) == 1
                    pv = pv - 10;
                    state = [pv, state(2), 0];
                else
                    % bust
                    player = pv;
                    break;
                end
            else
                state = [pv, state(2), state(3)];
            end
        elseif action == 0
            player = state(1);
            break;
        end
    end
   
    reward = -1;

    if player > 21
        % bust
        reward = -1;
    else
        % dealer turn
        dealerSecond = randi([1,11]);
        dealer = dealerSecond + state(2);
        dealerCards = [dealerSecond, state(2)];

        
        % soft 17 comment out to stick
        

        if dealer == 17 && ismember(11, dealerCards)
            % hit
            card = randi([1,11]);
            dealer = dealer + card;
        end

        while dealer < 17
            card = randi([1,11]);
            dealer = dealer + card;
        end

        if dealer > 21
            % dealer busts, reward 1
            reward = 1;
        elseif dealer > player
            % dealer won, reward -1
            reward = -1;
        elseif dealer == player
            % draw, reward 0
            reward = 0;
        elseif dealer < player
            % player won
            reward = 1;
        end
    end

    

    %MC ES Algorithm
    G = 0;
    for i = 1:size(iteration, 1)
        state = iteration(i, 1:3);
        action = iteration(i, 4);
        G = G + reward;

        
        mid = sprintf('%d %d ',state, action);
        index=temp(mid);
    
        k = find(~returns(index),1,'first');

        returns(index,k)=G;

        q(mid) = mean(nonzeros(returns(index)));

        if q(sprintf('%d %d ',state, 1)) > q(sprintf('%d %d ',state, 0))
            policy(sprintf('%d ',state)) = 1;
        else
            policy(sprintf('%d ',state)) = 0;
        end
    end
end


