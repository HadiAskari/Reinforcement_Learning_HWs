
states = [];
for playerTotal = 12:21
    for dealerCard = 1:10
        for ace = 0:1
            states = [states; [playerTotal, dealerCard, ace]];
        end
    end
end



actions = [1, 0];
q = dictionary();
returns = dictionary();
for ind = 1:200
    state = states(ind, :);
    key1 = make_key(state, 1);
    key2 = make_key(state, 0);
    q(key1) = 0;
    q(key2) = 0;
    returns(key1) = 0;
    returns(key2) = 0;
end
% 
% disp(q)
% 
% 
% disp(returns)



policy = dictionary();
for ind = 1:200
    state = states(ind, :);
    key = make_key(state, '');
    policy(key) = 0;
end

disp(policy)


for i = 1:500000
    [q, returns, policy] = play_episode(states, q, returns, policy);
end

x1_hit = [];
y1_hit = [];
x2_hit = [];
y2_hit = [];
x1_stick = [];
y1_stick = [];
x2_stick = [];
y2_stick = [];
for ind = 1:200
    state = states(ind, :);
    key = make_key(state, '');

    if state(3) == 1
        if policy(key) == 1
            x1_hit = [x1_hit; state(2)];
            y1_hit = [y1_hit; state(1)];
        else
            x1_stick = [x1_stick; state(2)];
            y1_stick = [y1_stick; state(1)];
        end
    elseif state(3) == 0
        if policy(key) == 1
            x2_hit = [x2_hit; state(2)];
            y2_hit = [y2_hit; state(1)];
        else
            x2_stick = [x2_stick; state(2)];
            y2_stick = [y2_stick; state(1)];
        end
    end
end

scatter(x1_hit, y1_hit, 20, 'red');
hold on;
scatter(x1_stick, y1_stick, 20, 'blue');
exportgraphics(gca, 'usable-ace-case1.pdf', 'Resolution', 300)

clf

scatter(x2_hit, y2_hit, 20, 'red');
scatter(x2_stick, y2_stick, 20, 'blue');
exportgraphics(gca, 'unusable-ace-case1.pdf', 'Resolution', 300)

function [q, returns, policy] = play_episode(states, q, returns, policy)
    episode = [];
    is_natural = false;

    % pick a random initial state
    state_index = randi(200, 1);
    state = states(state_index, :);

    % compute player value
    player_value = state(1);

    % check if natural
    if player_value == 21
        is_natural = true;
    end

    while true
        if is_natural
            break
        end

        % choose action based on policy
        key = make_key(state, '');
        action = policy(key);

        % save episode
        episode = [episode; [state, action]];

        % try action
        if action == 1
            card = randi(11, 1);
            new_value = card + state(1);

            if new_value > 21
                if state(3) == 1
                    new_value = new_value - 10;
                    state = [new_value, state(2), 0];
                else
                    % bust
                    player_value = new_value;
                    break;
                end
            else
                state = [new_value, state(2), state(3)];
            end
        elseif action == 0
            player_value = state(1);
            break;
        end

    end
    
    reward = -1;

    if is_natural
        dealer_face_down = randi(11, 1);
        dealer_value = dealer_face_down + state(2);
        if dealer_value == 21
            reward = 0;
        else
            reward = 1;
        end
    elseif player_value > 21
        % bust
        reward = -1;
    
    else
        dealer_face_down = randi(11, 1);
        dealer_value = dealer_face_down + state(2);

        % change this to <= 17 to trigger case 1 where
        % dealer hits on 17
        while dealer_value <= 17
            dealer_value = dealer_value + randi(11, 1);
        end

        if dealer_value > 21
            reward = 1;
        elseif dealer_value > player_value
            reward = -1;
        elseif dealer_value == player_value
            reward = 0;
        elseif dealer_value < player_value
            reward = 1;
        end
    end

    G = 0;
    gamma = 1;
    for ep = 1:size(episode, 1)
        G = gamma * G + reward;
        state = episode(ep, 1:3);
        action = episode(ep, 4);
        key = make_key(state, action);
        returns(key) = returns(key) + 1;
        q(key) = q(key) + ((reward - q(key)) / returns(key));

        if q(make_key(state, 1)) > q(make_key(state, 0))
            policy(make_key(state, '')) = 1;
        else
            policy(make_key(state, '')) = 0;
        end
    end
end



function key = make_key(state, action)
    key = sprintf('%d %d %d %d', state(1), state(2), state(3), action);
end