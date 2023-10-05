import time
import multiprocessing

# Define a sleeping task
def do_something(seconds):
  print('doing something that takes ' + str(seconds) + ' seconds')
  time.sleep(seconds)
  print('Task done')

### Define processes manually
def two_process():
    start = time.perf_counter()

    p1 = multiprocessing.Process(target=do_something, args=[2])
    p2 = multiprocessing.Process(target=do_something, args=[2])

    # What happens when I start my processes?
    p1.start()
    p2.start()

    # What happens if we actively join the process after we start it?
    p1.join()
    p2.join()
    
    finish = time.perf_counter()
    print('finished in ' + str(finish - start) + ' seconds')
    
    
def multiple_process():
    start = time.perf_counter()
    processes = []

    for x in range(60):
      p = multiprocessing.Process(target=do_something, args=[2])
      p.start()
      processes.append(p)

    # I need to join the processes to make sure they run before my finish
    # time is measured
    for process in processes:
      process.join()

    finish = time.perf_counter()
    print('finished in ' + str(finish - start) + ' seconds')
    
### Define processes using a pool
def process_pool():
  #Pools manage multiple processes for us
  start = time.perf_counter()

  data = [2 for i in range(60)]

  pool = multiprocessing.Pool(60)
  pool.map(do_something, data) # pool.map will map every value of the list 'data' into the function 'do_something' and then it will split it to any worker in the pool
  pool.terminate()
  pool.join()

  finish = time.perf_counter()
  print('finished in ' + str(finish - start) + ' seconds')
 

# This line tells my terminal what processes I want to run    
if __name__=="__main__":
    two_process()
    # multiple_process()
    # process_pool()