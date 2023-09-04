
[Policy, V] = value_iteration(0.1);
fprintf("Optimal Policy for Value Iteration: ");
disp(Policy(1:9));
fprintf("Optimal Value Function for Value Iteration: ");   
disp(V(2:10));

[policy, v]=policy_iteration(0.9);

fprintf("Optimal Policy for Policy Iteration: ");
disp(policy(1:9));
fprintf("Optimal Value Function for Policy Iteration: ");   
disp(v(2:10));


function [policy, V] = value_iteration(heads_prob)
    
    %set theta 
    theta = 0.001;
    
    %initialize V and policy to zero
    V = zeros(1, 19);
    policy = zeros(1, 19);

    while true
        %set delta
        delta = 0;
        % for each of the valid states
        for s = 1:9
            %Save old V value
            v = V(s+1);
            % for all possible actions
            actions = 1:s;
            %initialize q values
            q_values = zeros(1, length(actions));
            for i = 1:length(actions)
                %Update q values for each action win or lose
                bet = actions(i);
                win = heads_prob * (bet + V(s+bet+1));
                loss = (1-heads_prob) * (-bet + V(s-bet+1));
                q_values(i) = win + loss;
            end
            [new_v, index] = max(q_values);
            %Save new V value
            V(s+1) = new_v;
            % Update policy as the argmax of actions
            policy(s) = actions(index);
            %Compute Delta
            delta = max(delta, abs(v - V(s+1)));
        end
        if delta < theta
            break;
        end
    end
end



function [policy, V]= policy_iteration(heads_prob)


    %set theta 
    theta = 0.001;

    % create an random policy
    policy = 1:9;
    % initialize action values
    V = zeros(1, 19);
    stable = false;
    while ~stable
       %Policy evaluation
            delta = 1;
            while ~ delta < theta
                delta = 0;
                for state = 1:9
                    % save action-value
                    v = V(state + 1);
                    % get action 
                    bet = policy(state);
                    % compute action value
                    win = (heads_prob) * (bet + 1 * V(state + bet + 1));
                   
                    loss = (1 - heads_prob) * (-bet + 1 * V(state - bet + 1));
                    % update value
                    V(state + 1) = win + loss;
                    % Compute Delta
                    delta = max(delta, abs(v - V(state + 1)));
                end
            end
        
        %Policy Improvement
        stable = true;
        for state = 1:9
            % get previous action 
            old_action = policy(state);
            % get possible actions for this state
            values = zeros(1, state + 1);
            for bet = 1:state
              
                win = (heads_prob) * (bet + 1 * V(state + bet + 1));
              
                loss = (1 - heads_prob) * (-bet + 1 * V(state - bet + 1));
                % append to values
                values(bet + 1) = win + loss;
            end
            [~, policy(state)] = max(values);
            policy(state) = policy(state) - 1;
            if old_action ~= policy(state)
                stable = false;
            end
        end
    end
    

end



