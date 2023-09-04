import numpy as np
from random import random, choice
import matplotlib.pyplot as plt

# init gridworld
def gridworld(current_state, action):
    new_x, new_y = current_state
    if action == 'west':
        new_x -= 1
    elif action == 'east':
        new_x += 1
    elif action == 'north':
        new_y += 1
    elif action == 'south':
        new_y -= 1

    # terminal state
    if new_x == 0 and new_y == 11:
        return 0, (new_x, new_y)
    # cliff area
    if new_y == 0 and new_x in range(1, 11):
        return -100, (0, 0)
    # out of bound x
    if new_x < 0 or new_x > 11:
        return -1, current_state
    # out of bound y
    if new_y < 0 or new_y > 3:
        return -1, current_state
    # within bounds
    return -1, (new_x, new_y)
    

# def sarsa(q, actions, initial_state, final_state, episodes=10, 
#learning_rate=1, epsilon=0.1, gamma=1):
#     for ep_num in range(episodes):
#         state = initial_state
#         total_rewards = 0
#         while state != final_state:
#             if random() < epsilon:
#                 # explore
#                 action = choice(actions)
#                 pass
#             else:
#                 # exploit
#                 action = actions[np.argmax([q[(state, action)] for 
#action in actions])]

#             reward, next_state = gridworld(state, action)
#             q[(state, action)] += learning_rate * (reward + gamma * 
#max([q[(next_state, ac)] for ac in actions]) - q[(state, action)])
#             state = next_state
#             total_rewards += reward
        
#     return q


def q_learning(q, actions, initial_state, final_state, episodes=10, 
learning_rate=1, epsilon=0.1, gamma=1):
    rewards = []
    for ep_num in range(episodes):
        state = initial_state
        total_reward = 0
        while state != final_state:
            if random() < epsilon:
                # explore
                action = choice(actions)
                pass
            else:
                # exploit
                action = actions[np.argmax([q[(state, action)] for action 
in actions])]

            reward, next_state = gridworld(state, action)
            q[(state, action)] += learning_rate * (reward + gamma * 
max([q[(next_state, ac)] for ac in actions]) - q[(state, action)])
            state = next_state
            total_reward += reward
        rewards.append(total_reward)

    return q, rewards

if __name__ == '__main__':
    initial_state = (0, 0)
    final_state = (11, 0)
    states = [(i, j) for i in range(12) for j in range(4)]
    actions = ['north', 'south', 'west', 'east']

    total_rewards = []
    for i in range(1000):
        q = {}
        # arbitrary initialization of Q
        for state in states:
            for action in actions:
                q[(state, action)] = 0

        q, rewards = q_learning(q, actions, initial_state, final_state, 
episodes=500)
        total_rewards.append(rewards)

    plt.plot(np.mean(total_rewards, axis=0))
    plt.ylim((-100, 0))
    plt.show()

