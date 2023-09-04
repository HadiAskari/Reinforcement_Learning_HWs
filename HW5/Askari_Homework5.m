
initial_state = [1, 1];
final_state = [12, 1];

% states = [];
% 
% for i = 1:12
%     for j = 1:4
%         states(end+1, :) = [i, j];
%     end
% end

actions = [1, 2, 3, 4];

%disp(actions(1));


clf


disp("QLearning");



total_rewards = [];
for i = 1:100
    disp(i);
    %q = dictionary();
    %keys= java.util.Hashtable;

    % arbitrary initialization of Q
    % for j = 1:size(states, 1)
    %     for k = 1 : length(actions)
    %         q(sprintf('%d %d %d',states(j,1), states(j,2), actions(k)))=0;
    %         %keys.put([states(j,1), states(j,2), actions(k)], sprintf('%d %d %d',states(j,1), states(j,2), actions(k)));
    %     end
    % end

    q = zeros(12, 4, 4);



    %disp(keys)

    [q, rewards] = q_learning(q, actions, initial_state, final_state, 500);

    %[q, rewards] = sarsa(q, actions, initial_state, final_state, 500, 0.5, 0.1, 1);

    %[q, rewards] = expected_sarsa(q, actions, initial_state, final_state, 500, 0.5, 0.1, 1);


    total_rewards(end+1, :) = rewards;
end



plot(mean(total_rewards))

hold on;

disp("Sarsa");


total_rewards = [];
for i = 1:100
    disp(i);
    %q = dictionary();
    %keys= java.util.Hashtable;

    % arbitrary initialization of Q
    % for j = 1:size(states, 1)
    %     for k = 1 : length(actions)
    %         q(sprintf('%d %d %d',states(j,1), states(j,2), actions(k)))=0;
    %         %keys.put([states(j,1), states(j,2), actions(k)], sprintf('%d %d %d',states(j,1), states(j,2), actions(k)));
    %     end
    % end

    q = zeros(12, 4, 4);



    %disp(keys)

    %[q, rewards] = q_learning(q, actions, initial_state, final_state, 500);

    [q, rewards] = sarsa(q, actions, initial_state, final_state, 500, 0.5, 0.1, 1);

    %[q, rewards] = expected_sarsa(q, actions, initial_state, final_state, 500, 0.5, 0.1, 1);


    total_rewards(end+1, :) = rewards;
end



plot(mean(total_rewards))

hold on;

disp("Expected Sarsa");

total_rewards = [];
for i = 1:100
    disp(i);
    %q = dictionary();
    %keys= java.util.Hashtable;

    % arbitrary initialization of Q
    % for j = 1:size(states, 1)
    %     for k = 1 : length(actions)
    %         q(sprintf('%d %d %d',states(j,1), states(j,2), actions(k)))=0;
    %         %keys.put([states(j,1), states(j,2), actions(k)], sprintf('%d %d %d',states(j,1), states(j,2), actions(k)));
    %     end
    % end

    q = zeros(12, 4, 4);



    %disp(keys)

    %[q, rewards] = q_learning(q, actions, initial_state, final_state, 500);

    %[q, rewards] = sarsa(q, actions, initial_state, final_state, 500, 0.5, 0.1, 1);

    [q, rewards] = expected_sarsa(q, actions, initial_state, final_state, 500, 0.5, 0.1, 1);


    total_rewards(end+1, :) = rewards;
end




plot(mean(total_rewards))

legend('Q-Learning', 'Sarsa', 'Expected Sarsa')
xlim([0 500])
ylim([-100 0])


exportgraphics(gca, 'comparison_plot.pdf', 'Resolution', 400)







function [reward, new_state] = gridworld(current_state, action)


    new_x = current_state(1);
    new_y = current_state(2);


    if action == 1
        new_x = new_x - 1;
    elseif action == 2
        new_x = new_x + 1;
    elseif action == 3
        new_y = new_y + 1;
    elseif action == 4
        new_y = new_y - 1;
    end

    % Reaches goal
    if new_x == 1 && new_y == 12
        reward = 0;
        new_state = [new_x, new_y];
        return
    end


    % falls off a cliff
    if new_y == 1 && new_x > 1 && new_x <= 11
        reward = -100;
        new_state = [1, 1];
        return
    end


    % leaves x
    if new_x < 1 || new_x > 12
        reward = -1;
        new_state = current_state;
        return
    end


    % leaves y
    if new_y < 1 || new_y > 4
        reward = -1;
        new_state = current_state;
        return
    end


    % within the grid
    reward = -1;
    new_state = [new_x, new_y];


end




function [q, rewards] = q_learning(q, actions, initial_state, final_state, episodes, alpha, epsilon, gamma)
    if nargin < 8
        gamma = 1;
    end
    if nargin < 7
        epsilon = 0.1;
    end
    if nargin < 6
        alpha = 1;
    end
    if nargin < 5
        episodes = 500;
    end

    rewards = zeros(episodes, 1);
    for ep_num = 1:episodes
        state = initial_state;
        total_reward = 0;
        while ~isequal(state, final_state)
            if rand() < epsilon
                % explore
                action = actions(randi(length(actions)));
            else
                % exploit
                [~, action] = max(q(state(1), state(2), :));


            end

            [reward, next_state] = gridworld(state, action);

            %key=sprintf('%d %d %d',state(1), state(2), action);
            % max_q_next = -inf;
            % for ac = 1:length(actions)
            %     new_key=sprintf('%d %d %d',next_state(1),next_state(2), actions(ac));
            %     ac_value = q(new_key);
            %     if ac_value > max_q_next
            %         max_q_next = ac_value;
            %     end
            % end

            max_q_next=max(q(next_state(1), next_state(2), :));



            q(state(1), state(2), action) = q(state(1), state(2), action) + alpha * (reward + gamma * max_q_next - q(state(1), state(2), action));

            
            
            state = next_state;
            total_reward = total_reward + reward;


        end
        rewards(ep_num) = total_reward;
    end
end



% function [q, rewards] = sarsa(q, actions, initial_state, final_state, episodes, alpha, epsilon, gamma)
% 
%     % if nargin < 8
%     %     gamma = 1;
%     % end
%     % if nargin < 7
%     %     epsilon = 0.1;
%     % end
%     % if nargin < 6
%     %     alpha = 0.5;
%     % end
%     % if nargin < 5
%     %     episodes = 10;
%     % end
% 


function [q, rewards] = sarsa(q, actions, initial_state, final_state, episodes, alpha, epsilon, gamma)

    if nargin < 8
        gamma = 1;
    end
    if nargin < 7
        epsilon = 0.1;
    end
    if nargin < 6
        alpha = 0.5;
    end
    if nargin < 5
        episodes = 500;
    end

    rewards = zeros(episodes, 1);

    for ep_num = 1:episodes

        % disp(ep_num)

        state = initial_state;
        total_rewards = 0;

        % choose initial action
        if rand() < epsilon
            % explore
            action = actions(randi(length(actions)));
        else
            % exploit
            [~, action] = max(q(state(1), state(2), :));
        end



        while ~isequal(state, final_state)
            % take action A, observe R, S'
            [reward, next_state] = gridworld(state, action);

            % choose A' from S'
            if rand() < epsilon
                % explore
                next_action = actions(randi(length(actions)));
            else
                [~, next_action] = max(q(next_state(1), next_state(2), :));
   
            end


            % key=sprintf('%d %d %d',state(1), state(2), action);
            % next_key=sprintf('%d %d %d',next_state(1), next_state(2), action);

            % key=keys.get([state(1), state(2), action]);
            % next_key=keys.get([next_state(1), next_state(2), action]);
            
            % disp(state(1))
            % disp(next_state(1))
            % disp(action)

            q(state(1), state(2), action) = q(state(1), state(2), action) + alpha * (reward + gamma * q(next_state(1), next_state(2), next_action) - q(state(1), state(2), action));
            
            
            state = next_state;
            action = next_action;
            total_rewards = total_rewards + reward;
         end

        rewards(ep_num) = total_rewards;
    end
end


function [q, rewards] = expected_sarsa(q, actions, initial_state, final_state, episodes, alpha, epsilon, gamma)

    if nargin < 8
        gamma = 1;
    end
    if nargin < 7
        epsilon = 0.1;
    end
    if nargin < 6
        alpha = 0.5;
    end
    if nargin < 5
        episodes = 500;
    end

rewards = zeros(1, episodes);

for ep_num = 1:episodes

    %disp(ep_num)


    state = initial_state;
    total_reward = 0;

    % choose initial action
    if rand() < epsilon
        % explore
        action = actions(randi(length(actions)));
    else
        % exploit
        %action = actions(find(q(state, actions) == max(q(state, actions)), 1));
                    % exploit
        
       [~, action] = max(q(state(1), state(2), :));
 
    end

    while ~isequal(state, final_state)
        % take action A, observe R, S'

        [reward, next_state] = gridworld(state, action);

        %next_key=sprintf('%d %d %d',next_state(1), next_state(2), action);

        % figure out greediest action
        %best_action = actions(find(q(next_state, actions) == max(q(next_state, actions)), 1));

        [~, best_action] = max(q(next_state(1), next_state(2), :));
        

        % choose A' from S'
        if rand() < epsilon
            % explore
            next_action = actions(randi(length(actions)));
        else
            % exploit
            [~, next_action] = max(q(next_state(1), next_state(2), :));
        end

        % figure out action probabilities
        % epsilon % chance we choose best action
  
        expected_value = (1 - epsilon) * q(next_state(1), next_state(2), best_action);

        % (1 - epsilon) % chance we choose other 3 actions
        for action_new = actions
            if action_new ~= best_action
                %key=sprintf('%d %d %d',state(1), state(2), act);
                expected_value = expected_value + q(state(1), state(2), action_new) * epsilon;
            end
        end

        %key=sprintf('%d %d %d',state(1), state(2), action);
        
        %disp(action)

        q(state(1), state(2), action) = q(state(1), state(2),action) + alpha * (reward + gamma * expected_value - q(state(1), state(2), action));
        

        state = next_state;
        action = next_action;
        total_reward = total_reward + reward;
    end

    rewards(ep_num) = total_reward;
end

end





