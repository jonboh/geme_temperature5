package body Barreras is

   protected body Barrier is

      entry Wait when Opened is -- la tarea entra solo si opened es true
      begin
         if Wait'Count = 0 then Opened :=False; end if; --interpretaci�n: pongo el sem�foro en rojo si l n� de tareas en la cola de wait=0. por qu�???
         -- significa que yan han finalizado el acceso todas las tareas que est�n en la cola
      end Wait;

      procedure Go is
      begin
         Opened :=True; -- interpr: pongo sem�foro en verde
      end Go;

   end Barrier;
end Barreras;
-- Go-> pone opened a true
-- Wait-> pone opened a false si no tiene tareas esperando en la cola
