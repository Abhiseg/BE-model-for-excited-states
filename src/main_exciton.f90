        program main_exciton
       
        use param
        use init
        use spee
 
        implicit none

        real*8 :: en, &
                  en_nu, &
                  start, &
                  finish, &
                  eq12, &
                  eq26, &
                  eq28

        integer ::today(3), &
                  now(3), &
                  hostnm, &
                  status

        integer :: i, &
                   j, &
                   a_flag

        real*8  :: eq12_old, &
                   eq12_new, &
                   eq12_thres, &
                   eq12_diff, &
                   fosc

                                                                           

        CHARACTER*32 name


        status = hostnm( name )
        call idate(today)
        call itime(now)
        print*, 'JOB IS RUNNING ON HOST', ' ', name
        write ( *, 1000 )  today(1), today(2), today(3), now
 1000   format ( 'UNDER THE OPERATING SYSTEM LINUX ON:',' ', i2.2, '/', i2.2, '/', i4.4, '; AT: ', &
              i2.2, ':', i2.2, ':', i2.2 )
        call cpu_time(start)
        print*, "Initial Time", start

        a_flag=0
        eq12_thres=0.001d0
        eq12_old=0.0d0
        eq12_new=0.0d0


          dx=0.3d0

          print*,"             "
          print*,'----------------BE Model-------------'
          print*,"             "
          print*,'GRID SPACING',dx
          print*,"             "

          open(21, file='grid_spacing.dat',status='unknown')
          write(21,*) dx
          close(21)

          nx=80

          do i=1,10
          call orbital_indices
          ny=nx
          nz=nx             
          open(20, file='std_grid.dat', status='old')
          write(20,*) nx,ny,nz
          close(20)
          call read_input
          
          call read_basis    
          call gen_allocate  
          call set_grid        
          call orbital_maps
          call bas_fun_grid
          open(23,file="mo_en.dat",status="old")
          read(23,*) expc_en, expc_en1
          close(23)
          
          call stsplit
          call deallo
                             
          eq12=(expc_en1-expc_en+sts3)   


         !---------oscillator strength in atomic unit --------------
           fosc = (2.d0/3.d0) * eq12 * (mux*mux + muy*muy + muz*muz)

                  
          print*,'Cycle:',i
          print*, "N_x=", nx, "N_y=", ny, "N_z=", nz 
          print*, "Ground State Energy (a.u.) = ", expc_en
          print*, "Triplet State Energy (a.u.) = ", expc_en1
          print*, "triplet-excitation energy in ev=", (expc_en1- &
                                                      expc_en)*au_t_ev
          print*, "Kif (eV)=", sts3*au_t_ev
          print*, "Osc. Strength (a.u.)=", fosc, "and Singlet-Excitation energy (eV) =", eq12*au_t_ev
       
          eq12_diff=abs(eq12*au_t_ev-eq12_old)

          nx=nx+4
          if(eq12_diff .le. eq12_thres) exit
          eq12_old=eq12*au_t_ev
          print*,"             "
 
          enddo
 
          print*, "   "
         
          call cpu_time(finish)
          print*, "Final Time", finish
          print*, "Job is completed successfully"
                  

      end program main_exciton
