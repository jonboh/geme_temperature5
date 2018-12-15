package geme_mock is
   gain_wats_volt: constant Float := 80.0;
   gain_volt_temp: constant Float := 20.0;
    procedure Initialize_PCM3712;
    procedure Write_ao_PCM3712(Volts: Float);
    procedure Configuracion_Inicial(Conexion: String; Canal_Primero: Integer; Canal_Ultimo: Integer; Disparo: String; Numero_Muestras: Integer; Rango: String);
    function Adquirir return Float;
    procedure Fin_Adquisicion;
end geme_mock;
