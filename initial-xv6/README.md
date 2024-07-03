
# Testing system calls

## Running Tests for getreadcount

Running tests for this syscall is easy. Just do the following from
inside the `initial-xv6` directory:

```sh
prompt> ./test-getreadcounts.sh
```

If you implemented things correctly, you should get some notification
that the tests passed. If not ...

The tests assume that xv6 source code is found in the `src/` subdirectory.
If it's not there, the script will complain.

The test script does a one-time clean build of your xv6 source code
using a newly generated makefile called `Makefile.test`. You can use
this when debugging (assuming you ever make mistakes, that is), e.g.:

```sh
prompt> cd src/
prompt> make -f Makefile.test qemu-nox
```

You can suppress the repeated building of xv6 in the tests with the
`-s` flag. This should make repeated testing faster:

```sh
prompt> ./test-getreadcounts.sh -s
```

---

## Running Tests for sigalarm and sigreturn

**After implementing both sigalarm and sigreturn**, do the following:
- Make the entry for `alarmtest` in `src/Makefile` inside `UPROGS`
- Run the command inside xv6:
    ```sh
    prompt> alarmtest
    ```

---

## Getting runtimes and waittimes for your schedulers
- Run the following command in xv6:
    ```sh
    prompt> schedulertest
    ```  
---

## Running tests for entire xv6 OS
- Run the following command in xv6:
    ```sh
    prompt> usertests
    ```

---




# Scheduling Report (Specification 3)

## Implementation of FCFS
In FCFS, I first disabled the preemption (just didnot call the yield() function).
(
    yield is for giving the control to the OS.
) 
then at every interrupt I am checking for the process having the oldest creation time (p->ctime) and then making it run till finishing.


## Implementation of MLFQ
### Priority Queue-Based Scheduler with Aging Implementation Description

In our system, we have implemented a priority queue-based scheduler to efficiently manage and allocate CPU time to processes. The scheduler uses four priority queues, with the highest priority assigned to queue number 0 and the lowest priority to queue number 3. Each priority queue has a different time-slice allocated for executing processes, which ensures that higher-priority tasks receive more frequent CPU time.

### Initialization and Process Entry:

When a process is initiated, it is pushed to the end of the highest priority queue (queue 0 by default).
The scheduler always runs the process in the highest priority queue that is not empty, ensuring that critical tasks get immediate attention.
Preemption and Time-Slice:

If a process in a higher-priority queue becomes available (e.g., a process enters queue 0), it preempts the currently running process in a lower-priority queue (if any).
Each priority queue has a specific time-slice allocated for execution:
Priority 0: 1 timer tick
Priority 1: 3 timer ticks
Priority 2: 9 timer ticks
Priority 3: 15 timer ticks
If a process uses its complete time slice in its current priority queue, it is preempted and moved to the next lower priority queue.
Voluntary Relinquishing of CPU Control:

When a process voluntarily relinquishes control of the CPU, such as for I/O operations, it leaves the queuing network.
When the process becomes ready again after I/O, it is inserted at the tail of the same queue from which it was relinquished earlier.
Round-Robin Scheduler for Lowest Priority Queue:

The lowest priority queue (queue 3) uses a round-robin scheduling algorithm to ensure that all processes in this queue get a fair share of CPU time.
Aging to Prevent Starvation:

To prevent process starvation in lower-priority queues, we implement aging of processes.
If the wait time of a process in a priority queue (other than priority 0) exceeds a certain limit (30s)(set to prevent starvation), their priority is increased.
The aging process ensures that processes that have been waiting for a long time in lower-priority queues gradually move up to higher-priority queues, giving them a chance to execute sooner.
The wait time for a process is reset to 0 whenever the scheduler selects it for execution or when a change in the queue occurs due to aging.
Overall, this priority queue-based scheduler with aging effectively manages process execution, giving higher priority to critical tasks, preventing starvation of lower-priority processes, and ensuring fair access to CPU time for all processes in the syst


I have not made actual queues , just included extra entry called "queue" and iterating all over to check the queue numbers.


## Performance Comparison

The following shows the average runtimes and average waiting times of the 10 child processes (5 I/O bound and 5 CPU bound) spawned by the `schedulertest` process, all on one CPU
-------
CPUS:1
FCFS:Average rtime 10,  wtime 120
RR:Average rtime 9,  wtime 138
MLFQ:Average rtime 10,  wtime 135

## Timeline graph for MLFQ
[!click](MLFQ_image.png)


# Scheduling Algorithm Performance Comparison

 In this project, we've implemented and compared three popular scheduling algorithms: Round Robin (RR), First-Come, First-Served (FCFS), and Multi-Level Feedback Queue (MLFQ). The comparison is based on their average response time (rtime) and average waiting time (wtime).


## Here's how the average waiting times compare:

- *FCFS* stands out with the lowest average waiting time (144), indicating that processes spend less time waiting in the queue before execution.
- *RR* has a somewhat higher average waiting time (183) compared to FCFS, implying that processes, on average, wait longer in the queue before getting a chance to execute.
- *MLFQ* demonstrates a waiting time (185) close to that of RR, suggesting a similar average waiting time.

## Conclusion:

- *FCFS* performs exceptionally well in terms of average waiting time, offering the lowest waiting time for processes.
- *RR* and *MLFQ* exhibit similar average waiting times, with RR having a slightly lower average waiting time.