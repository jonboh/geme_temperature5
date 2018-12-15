package body Barreras is

   protected body Barrier is

      entry Wait when Opened is -- la tarea entra solo si opened es true
      begin
         if Wait'Count = 0 then Opened :=False; end if; --interpretación: pongo el semáforo en rojo si l nº de tareas en la cola de wait=0. por qué???
         -- significa que yan han finalizado el acceso todas las tareas que están en la cola
      end Wait;

      procedure Go is
      begin
         Opened :=True; -- interpr: pongo semáforo en verde
      end Go;

   end Barrier;
end Barreras;
-- Go-> pone opened a true
-- Wait-> pone opened a false si no tiene tareas esperando en la cola
