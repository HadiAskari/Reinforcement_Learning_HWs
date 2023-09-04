
disp('Heads Prob = 0.9')
policy_evaluation(0.9);

disp('Heads Prob = 0.1')
policy_evaluation(0.1);


function policy_evaluation(Prob_of_head)

    % Initialize V to hold states
    V = zeros(1, 19);
    delta = 0;
    disp('Aggressive Policy')
    while delta < 0.0001
        % possible states
        for s = 1:9
            % Save pre
          
            v = V(s + 1);

            % Aggressive Policy

            actions = s;
            
            % Update vals
            val = 0;
            for bet = actions
                % P heads
                heads = (Prob_of_head) * (bet + 1 * V(s + bet + 1));
                %P tails
                tails = (1 - Prob_of_head) * (-bet + 1 * V(s - bet + 1));
                % probability of action
                prob_of_action = 1 / length(actions);
                val = val + (heads + tails) * prob_of_action;
            end
            % update val of state
            V(s + 1) = val;
            % update delta
            delta = max(delta, abs(v - V(s + 1)));
        end
    disp(V(1:10))
    end

    % Initialize V to hold states
    V = zeros(1, 19);
    delta = 0;
    disp('Conservative Policy')

    while delta < 0.0001
        % possible states
        for s = 1:9
            % Save pre
            
            v = V(s + 1);

            % Conservative Policy


            actions = 1;
        
            
            % Update vals
            val = 0;
            for bet = actions
                % P heads
                heads = (Prob_of_head) * (bet + 1 * V(s + bet + 1));
                %P tails
                tails = (1 - Prob_of_head) * (-bet + 1 * V(s - bet + 1));
                % probability of action
                prob_of_action = 1 / length(actions);
                val = val + (heads + tails) * prob_of_action;
            end
            % update val of state
            V(s + 1) = val;
            % update delta
            delta = max(delta, abs(v - V(s + 1)));
        end
    disp(V(1:10))
    end

    % Initialize V to hold states
    V = zeros(1, 19);
    delta = 0;
    disp('Random Policy')

    while delta < 0.0001
        % possible states
        for s = 1:9
            % Save pre
            
            v = V(s + 1);

            % Random Policy

            actions = 1:s;
        
            
            % Update vals
            val = 0;
            for bet = actions
                % P heads
                heads = (Prob_of_head) * (bet + 1 * V(s + bet + 1));
                %P tails
                tails = (1 - Prob_of_head) * (-bet + 1 * V(s - bet + 1));
                % probability of action
                prob_of_action = 1 / length(actions);

                val = val + (heads + tails) * prob_of_action;
            end
            % update val of state
            V(s + 1) = val;
            % update delta
            delta = max(delta, abs(v - V(s + 1)));
        end
    disp(V(1:10))
    end
end


