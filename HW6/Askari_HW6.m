
clf;

true_val=get_true_value();

plot(1:1000,true_val(2:1001));

hold on;

vals = get_monte_carlo(2e-4, 100000);
plot(1:1000, vals(2:1001));

hold on;

vals = get_td_0(2e-4, 100000);
plot(1:1000, vals(2:1001));


legend('True Values', 'Approximate MC Values', 'Approximate TD(0) Values')
xlabel('States')
ylabel('Values')

legend('Location','northwest')

exportgraphics(gca, 'Q1.pdf', 'Resolution', 250)



function val = state_vals(state, true_val)
    if state < 1
        val = -1;
    elseif state > 1000
        val = 1;
    else
        val = true_val(state);
    end
end


function true_value = get_true_value()
    
    true_value = zeros(1002, 1);
    change = 10;
    
    while change > 1e-4
        change=0;
        
        for state=2:1001

            v=true_value(state);


            left=state - 100:state-1;
            right=state+1:state+100;

            next_states=[left,right];

            next=0;

            for i=1:size(next_states, 2)

                if next_states(i) < 1
                    next_state = 1;
                elseif next_states(i) > 1002
                    next_state = 1002;
                else
                    next_state = next_states(i);
                end 

                if next_state < 2
                    reward = -1;
                elseif next_state > 1001
                    reward = 1;
                else
                    reward = 0;
                end
                
                next = next + (1 / 200) * (reward + true_value(next_state));


            end

            true_value(state) = next;
            change=max(change,abs(v-true_value(state)));
        end
    end
end




function state_values = get_monte_carlo(a, episodes)
    weights = zeros(10, 1);

    for e=1:episodes
 
        current_state = 500;
        episode = [];

        while ~(current_state < 2 || current_state > 1001)
            
            left=current_state - 100:current_state-1;
            right=current_state+1:current_state+100;
            
            next_states=[left,right];


            num_columns = size(next_states, 2);
            random_column = randi(num_columns);
            next_state = next_states(random_column);

            
            episode(end+1) = current_state;
            current_state = next_state;
        end

    
        if current_state < 2
            final_reward = -1;
        elseif current_state > 1001
            final_reward = 1;
        else
            final_reward = 0;
        end


        for state=episode
            state_minus_2 = state - 2;
            division_result = state_minus_2 / 100;
            ids = floor(division_result) + 1;

            weights(ids) = weights(ids) + a * (final_reward - weights(ids));
        end
    end

    
    state_values = zeros(1002, 1);
    for state=2:1001
        temp=floor((state - 2) / 100) + 1;
        state_values(state) = weights(temp);
    end

end

function state_values = get_td_0(a, episodes)
 
    weights = zeros(10, 1);
    

    for e=1:episodes
  
        current_state = 500;
      
        while ~(current_state < 2 || current_state > 1001)
          
            left=current_state - 100:current_state-1;
            right=current_state+1:current_state+100;
            
            next_states=[left,right];


            num_columns = size(next_states, 2);
            random_column = randi(num_columns);
            next_state = next_states(random_column);


        
            if next_state < 2
                reward = -1;
            elseif next_state > 1001
                reward = 1;
            else
                reward = 0;
            end

         
            state_minus_2 = current_state - 2;
            division_result = state_minus_2 / 100;
            ids = floor(division_result) + 1;


            
            weight_2 = 0;
            if ~(next_state < 2 || next_state > 1001)
                temp=floor((next_state - 2) / 100) + 1;
                weight_2 = weights(temp);
            end

           
            weights(ids) = weights(ids) + a * (reward + weight_2 - weights(ids));

           
            current_state = next_state;
        end
    end

   
    state_values = zeros(1002, 1);
    for state=2:1001
        temp=floor((state - 2) / 100) + 1;
        state_values(state) = weights(temp);
    end
end
