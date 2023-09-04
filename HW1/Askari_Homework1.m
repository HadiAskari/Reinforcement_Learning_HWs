close all

true_rewards = normrnd(0, 1, [1, 10]);

% computing rewards over 2000 experiments for epsilon greedy 
total_reward_collected = [];
for a = 1:2000
    % initialize action-value
    q = zeros(1, 10);
    % actions taken
    n = zeros(1, 10);
    % save rewards
    rewards = zeros(1, 1000);

    for step_count = 1:1000
        % Epsilon Greedy Algorithm
        if randn() < 0.1
        % explore 
            index = randi([1, 10]);
        else
         % exploit 
            [~, index] = max(q);
        end


        % sample a reward from the true value using the index 
        reward = normrnd(true_rewards(index), 1);
        % increment count of action
        n(index) = n(index) + 1;
        % update action-value estimate
        q(index) = q(index) + (1 / n(index)) * (reward - q(index));
        % add reward to rewards
        rewards(step_count) = reward;
    end

    total_reward_collected = [total_reward_collected; rewards];

end


% compute rewards over 2000 experiments for UCB
total_rewards_collected_2 = [];
for a = 1:2000
    % initialize action-value
    q = zeros(1, 10);
    % actions taken
    n = zeros(1, 10);
    % save rewards
    rewards = zeros(1, 1000);

    for step_count = 1:1000
        ucb_vals = [];
        index=-1;
        for ind = 1:10
            if n(ind) == 0
                index = ind;
                break
            end
    
            % compute UCB
            ucb = q(ind) + 2 * sqrt(log(step_count) / n(ind));
            ucb_vals = [ucb_vals; ucb];
        end
        % return index of max UCB after we have explored all initial
        % actions
        if index == -1
            [~, index] = max(ucb_vals);
        end

        % sample a reward from the true value using the index
        reward = normrnd(true_rewards(index), 1);
        % increment count of action
        n(index) = n(index) + 1;
        % update action-value estimate
        q(index) = q(index) + (1 / n(index)) * (reward - q(index));
        % add reward to rewards
        rewards(step_count) = reward;
    end

    total_rewards_collected_2 = [total_rewards_collected_2; rewards];
    

end

plot(1:1000, mean(total_reward_collected))
hold on;
plot(1:1000, mean(total_rewards_collected_2))
legend('\epsilon-greedy = 0.1', 'UCB c = 2')
legend('Location', 'southeast')
xlabel('Steps')
ylabel('Average reward')
xlim([0 1000])

ax=gca;
% save the figure
exportgraphics(ax, 'Fig.pdf', 'Resolution', 250)
