package PerTask_gen is

   	task type Periodic_Task (Id, Prio, Period, Deadline: Integer; Proc : not null access procedure) is
      		pragma Priority(Prio);
   	end Periodic_Task;

end PerTask_gen;
