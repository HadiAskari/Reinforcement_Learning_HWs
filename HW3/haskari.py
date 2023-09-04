import numpy as np

def value_iteration(heads_prob, theta=0.001):
    # max amount is 18
    V = np.zeros(19)
    policy = np.zeros(19)

    while True:
        delta = 0
        for s in range(1, 10):
            v = V[s]
            actions = range(1, min(s, 19 - s) + 1)
            q_values = []
            for bid in actions:
                win_value = heads_prob * (bid + V[s+bid])
                lose_value = (1-heads_prob) * (-bid + V[s-bid])
                q_values.append(win_value + lose_value)
            new_v = max(q_values)
            V[s] = new_v
            print(V)
            policy[s] = actions[np.argmax(q_values)]
            delta = max(delta, abs(v - V[s]))
        if delta < theta:
            break
    return policy, V

policy, V = value_iteration(0.9)
print("Optimal Policy: ", policy[1:10])
print("Optimal Values: ", V)



