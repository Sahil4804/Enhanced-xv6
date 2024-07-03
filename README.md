# xv6

### Priority-based Scheduling

This is a priority-based scheduling policy that chooses the process with the highest priority to execute. If two or more processes have the same priority, we break the tie using the number of times the process has been scheduled. If the tie persists, use the process's start time to break it (processes with lower start times are scheduled earlier).

We have static priority and dynamic priority here. Dynamic priority determines scheduling by varying with running, waiting and sleeping time. Dynamic priority is calculated using static priority.


#### Implementation

-   Once again, we use a for loop to find the process with the highest priority (lowest dynamic priority),  In case two or more processes have the same priority, we use the number of times the process has been scheduled to break the tie. If the tie remains, use the start-time of the process to break the tie(processes with lower start times should be scheduled further). Then the selected process is scheduled to run.

-   The number of ticks,dynamicstime,dynamicrtime and wtime  are stored in struct proc::s. In the Updatetime() function, the values of these parameters are updated accordingly.
In the same loop i have updated the RBI and Dynamic Priority of each process.

-   struct proc'  stores the static priority (50 by default). When the process to be scheduled is selected, the RBI and dynamic priority are calculated in the loop.

-   A process's static priority can be modified using the 'set priority()' system call. In this function, i have updated the static priority of the process and also set the RBI to 25 and Dynamic Priority of the process accordingly and also returns the old priority.

```bash
setpriority [priority] [pid]
```


# Effectiveness of Static Priority (SP): 
### Observation:
- SP represents the inherent priority of a process which ranges from 0 to 100. Lower SP values indicate higher priority for scheduling. It's default value for each process is 50. Analysis: Decreasing the SP(Static priority) of a process increases its priority, making it more likely to be scheduled. Increasing the SP lowers the priority, potentially delaying the process's execution. Outcome : So we can make a process to get scheduled fast or gets delayed by using SP(Static priority) parameter of a process by using set_priority system call.

# Effectiveness of RBI (RTime, WTime, STime):
### Observation:
- RBI is a weighted sum of Running Time (RTime), Sleeping Time (STime), and Waiting Time (WTime). RBI adjusts the dynamic priority based on recent behavior. It's default value will be 25 for each process.
### Running Time (RTime):
- The total time the process has been running since it was last scheduled. A process with high RTime might have a higher RBI, indicating a potential increase in dynamic priority and thus overall decrease the chances of that process to get rescheduled.
### Sleeping Time (STime): 
- The total time the process has spent sleeping (i.e., blocked and not using CPU time) since it was last scheduled. High STime decreases the RBI, potentially reducing dynamic priority which increases the chances of that process to get rescheduled with respect to others.
### Waiting Time (WTime):
- The total time the process has spent in the ready queue waiting to be scheduled. A process waiting for a long time may have a lower RBI as it is with minus sign in numerator so decreasing the RBI value, and decreasing the dynamic Priority and thus overall increasing priority to get scheduled.
### Weighted Sum:
- The weighted sum captures the overall recent behavior impact on priority.


# Analysis of PBS (DP):

PBS Analysis:
![plt_Photo](meraplt.png)

## Effectiveness of Static Priority (SP): 
### Observation:
- SP represents the inherent priority of a process which ranges from 0 to 100. Lower SP values indicate higher priority for scheduling. It's default value for each process is 50. Analysis: Decreasing the SP(Static priority) of a process increases its priority, making it more likely to be scheduled. Increasing the SP lowers the priority, potentially delaying the process's execution. Outcome : So we can make a process to get scheduled fast or gets delayed by using SP(Static priority) parameter of a process by using set_priority system call.

## Effectiveness of RBI (RTime, WTime, STime):
### Observation:
- RBI is a weighted sum of Running Time (RTime), Sleeping Time (STime), and Waiting Time (WTime). RBI adjusts the dynamic priority based on recent behavior. It's default value will be 25 for each process.
### Running Time (RTime):
- The total time the process has been running since it was last scheduled. A process with high RTime might have a higher RBI, indicating a potential increase in dynamic priority and thus overall decrease the chances of that process to get rescheduled.
### Sleeping Time (STime): 
- The total time the process has spent sleeping (i.e., blocked and not using CPU time) since it was last scheduled. High STime decreases the RBI, potentially reducing dynamic priority which increases the chances of that process to get rescheduled with respect to others.
### Waiting Time (WTime):
- The total time the process has spent in the ready queue waiting to be scheduled. A process waiting for a long time may have a lower RBI as it is with minus sign in numerator so decreasing the RBI value, and decreasing the dynamic Priority and thus overall increasing priority to get scheduled.
### Weighted Sum:
- The weighted sum captures the overall recent behavior impact on priority.

## Impact on Dynamic Priority (DP):

## Observation:
- DP is the minimum of (sum of SP and RBI) and 100. DP determines the order of process execution.
- Analysis: Processes with lower DP values get scheduled first. SP and RBI interact to dynamically adjust the priority. Frequent adjustments ensure responsiveness to changing behavior by using set_priority syscall.

## Average Turnaround Time:
### Advantages in Terms of Average Turnaround Time:
- Allows for prioritization of tasks, potentially leading to shorter turnaround times for high-priority tasks. Can be more adaptive to changing workload requirements, dynamically adjusting priorities.

### Disadvantages in Terms of Average Turnaround Time: 
- If priorities are not managed effectively, low-priority tasks may experience longer waiting times. Priority inversion issues, where high-priority tasks are blocked by lower-priority tasks, can impact average turnaround time.

## Throughput:
### Advantage:
- PBS can optimize throughput by allowing higher-priority tasks to be scheduled more frequently.
### Disadvantage:
- Lower-priority tasks may experience reduced throughput, potentially leading to resource starvation.

## Responsiveness:
### Advantage:
- PBS can provide better responsiveness by giving priority to high-priority tasks.
### Disadvantage:
- Low-priority tasks may experience reduced responsiveness or even starvation.

## Fairness:
### Advantage:
- PBS can be fairer than some other scheduling algorithms by allowing lower-priority tasks to execute.
### Disadvantage:
- In scenarios with a large number of high-priority tasks, lower-priority tasks may experience reduced fairness.

## Complexity:
### Advantage:
- PBS is flexible and allows dynamic adjustment of priorities, making it suitable for diverse workloads.
### Disadvantage:
- The flexibility introduces complexity in priority management and may lead to priority inversion issues.

## Implementation Overhead:
### Advantage:
- PBS can have a moderate implementation overhead compared to more complex algorithms.
### Disadvantage:
- The need for priority management can increase implementation complexity.

## Adaptability:
### Advantage:
- PBS is adaptable to changing workload requirements by dynamically adjusting priorities.
### Disadvantage:
- Frequent adjustments may lead to increased overhead and potential disruptions.

## Advantages of Priority-Based Scheduling (PBS):

## Prioritization:
- Allows tasks to be prioritized based on importance or urgency, leading to optimized scheduling for critical tasks.

## Flexibility:
- Can dynamically adjust priorities, making it suitable for environments with varying workload characteristics.

## Responsiveness:
- Provides better responsiveness by giving preference to high-priority tasks.

## Fairness:
- Can be fairer than some other scheduling algorithms, ensuring that lower-priority tasks are not completely starved.

## Disadvantages of Priority-Based Scheduling (PBS):

## Priority Inversion:
- May suffer from priority inversion issues, where high-priority tasks are blocked by lower-priority tasks.

## Starvation:
- If not managed effectively, low-priority tasks may face increased waiting times or even starvation.

## Complexity:
- The flexibility and prioritization introduce complexity in priority management and may require careful implementation.

## Assumptions
I have not taken the default value for the intial RBI.



## Bibliography

1. *ChatGPT Documentation:*
   - [OpenAI ChatGPT Documentation](https://platform.openai.com/docs/guides/chat)
   - [OpenAI GPT-3.5 Model Documentation](https://platform.openai.com/docs/models/gpt)

2. *GitBook.io Guides:*
   - [Markdown Guide on GitBook.io](https://xiayingp.gitbook.io/build_a_os/hardware-device-assembly/start-xv6-and-the-first-process)

3. *Github Co-Pilot:*
    - [Markdown Guide on Github-Co-Pilot Documentation](https://docs.github.com/en/copilot)





