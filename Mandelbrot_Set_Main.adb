-------------------------------------------------------------------------------
--                                                                           --
--                          Mandelbrot Set Generator                         --
--                                                                           --
--                          Mandelbrot_Set_Main.adb                          --
--                                                                           --
--                                  MAIN                                     --
--                                                                           --
--                   Copyright (C) 1996 Ulrik Hørlyk Hjort                   --
--                                                                           --
--  Mandelbrot Set Generator is free software;  you can  redistribute it     --
--  and/or modify it under terms of the  GNU General Public License          --
--  as published  by the Free Software  Foundation;  either version 2,       --
--  or (at your option) any later version.                                   --
--  Mandelbrot Set Generator is distributed in the hope that it will be      --
--  useful, but WITHOUT ANY WARRANTY;  without even the  implied warranty    --
--  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  --
--  See the GNU General Public License for  more details.                    --
--  You should have  received  a copy of the GNU General                     --
--  Public License  distributed with Yolk.  If not, write  to  the  Free     --
--  Software Foundation,  51  Franklin  Street,  Fifth  Floor, Boston,       --
--  MA 02110 - 1301, USA.                                                    --
--                                                                           --
-------------------------------------------------------------------------------

with Mandelbrot_Set;use Mandelbrot_Set;

procedure Mandelbrot_Set_Main is

begin
 Generate("./data/Mandel", 640,480);
 Generate("./data/Mandel2", 640,480);
 Generate("./data/Mandel3", 640,480);
 Generate("./data/Mandel4", 640,480);
 Generate("./data/Mandel5", 640,480);
 Generate("./data/Mandel6", 640,480);
end Mandelbrot_Set_Main;
