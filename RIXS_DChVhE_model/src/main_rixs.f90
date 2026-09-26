! Unified driver: core + valence becke_kif + mixed emission (osc/).
        program main_rixs
        use param
        use init
        use spee
        implicit none

        character(len=32) :: name
        integer :: today(3), now(3), hostnm, status
        real*8 :: start, finish
        real*8 :: core_exc_ev, val_exc_ev, rixs_emission_ev
        real*8 :: emission_fosc

        status = hostnm(name)
        call idate(today)
        call itime(now)
        print*, 'BECKE_KIF driver on host ', trim(name)
        write(*, '(A,I2.2,A,I2.2,A,I4.4,A,I2.2,A,I2.2,A,I2.2)') &
            ' Date: ', today(2), '/', today(1), '/', today(3), &
            '  Time: ', now(1), ':', now(2), ':', now(3)
        call cpu_time(start)

        call run_exciton_calc('core', 'STS_core.out', eq12_ev_out=core_exc_ev)
        call run_exciton_calc('valence', 'STS_valence.out', eq12_ev_out=val_exc_ev)

        rixs_emission_ev = core_exc_ev - val_exc_ev

        call check_osc_inputs()
        call run_exciton_calc('osc', 'osc.dat', fosc_out=emission_fosc)

        call write_rixs_summary(core_exc_ev, val_exc_ev, rixs_emission_ev, emission_fosc)

        call cpu_time(finish)
        print*, 'Total CPU time (s):', finish - start
        print*, 'Done. See STS_core.out, STS_valence.out, osc.dat, and RIXS.out'

        contains

        subroutine check_osc_inputs()
          logical :: ex

          inquire(file='osc/mo_cf.dat', exist=ex)
          if (.not. ex) stop 'osc/mo_cf.dat required (user-prepared)'
          inquire(file='osc/en.dat', exist=ex)
          if (.not. ex) stop 'osc/en.dat required (user-prepared)'
          inquire(file='osc/mo_en.dat', exist=ex)
          if (.not. ex) stop 'osc/mo_en.dat required (user-prepared)'
        end subroutine check_osc_inputs

        subroutine run_exciton_calc(dirname, logfile, fosc_out, eq12_ev_out)
          character(len=*), intent(in) :: dirname, logfile
          real*8, intent(out), optional :: fosc_out, eq12_ev_out

          integer :: i, j, ios
          real*8 :: eq12, eq26, eq28, fosc
          real*8 :: eq12_old, eq12_thres, eq12_diff
          real*8 :: run_finish

          data_prefix = trim(dirname)//'/'
          eq12_thres = 0.001d0
          eq12_old = 0.0d0

          close(6)
          open(6, file=logfile, status='replace', action='write')

          dx = 0.3d0
          print*, 'CT-Excitation (data dir: ', trim(data_prefix), ')'
          print*, 'Basis:6-311++G and Mol: C2h4-C2F4'
          do j = 1, 1
          print*, 'GRID SPACING', dx

          open(21, file='grid_spacing.dat', status='unknown')
          write(21,*) dx
          close(21)

          nx = 80

          do i = 1, 10
          call orbital_indices
          ny = nx
          nz = nx
          open(20, file='std_grid.dat', status='old')
          write(20,*) nx, ny, nz
          close(20)
          call read_input
          call read_basis
          call gen_allocate
          call set_grid
          call orbital_maps
          call bas_fun_grid

          open(23, file=trim(data_prefix)//'en.dat', status='old')
          read(23,*) expc_en, expc_en1
          close(23)

          call stsplit
          call deallo

          eq26 = (expc_en1 - expc_en + sts2)
          eq28 = (expc_en1 - expc_en + sts1)
          eq12 = (expc_en1 - expc_en + sts3)
          fosc = (2.d0/3.d0) * (-1.0d0) * eq12 * (mux*mux + muy*muy + muz*muz)

          print*, 'N_x=', nx, 'N_y=', ny, 'N_z=', nz
          print*, 'ground state energy = ', expc_en
          print*, 'first lowest triplet state energy = ', expc_en1
          print*, 'osc str in au=', fosc, 'singlet-excitation energy in ev=', eq12*au_t_ev
          print*, 'Kif in ev=', sts3*au_t_ev
          print*, 'triplet-excitation energy in ev=', (expc_en1 - expc_en)*au_t_ev

          eq12_diff = abs(eq12*au_t_ev - eq12_old)
          nx = nx + 4
          if (eq12_diff .le. eq12_thres) exit
          eq12_old = eq12*au_t_ev
          enddo

          dx = dx + 0.1d0
          print*, '*************************************************'
          enddo

          print*, '----------------------------------'
          call cpu_time(run_finish)
          print*, 'job is completed successfully'

          if (present(fosc_out)) fosc_out = fosc
          if (present(eq12_ev_out)) eq12_ev_out = eq12*au_t_ev

          close(6)
          open(6, file='/dev/tty', status='old', action='write', iostat=ios)
          if (ios /= 0) open(6, file='/dev/null', status='old', action='write')
        end subroutine run_exciton_calc

        subroutine write_rixs_summary(core_exc, val_exc, rixs_em, fosc)
          real*8, intent(in) :: core_exc, val_exc, rixs_em, fosc
          integer :: iu

          open(newunit=iu, file='RIXS.out', status='replace')
          write(iu,'(A)') '# RIXS emission (core STS - valence STS; osc from osc/)'
          write(iu,'(A,ES24.16)') 'core_excitation_eV        ', core_exc
          write(iu,'(A,ES24.16)') 'valence_excitation_eV     ', val_exc
          write(iu,'(A,ES24.16)') 'rixs_emission_energy_eV   ', rixs_em
          write(iu,'(A,ES24.16)') 'emission_osc_strength_au  ', fosc
          close(iu)

          print*, '----------------------------------------------'
          print*, 'Core excitation (eV)     = ', core_exc
          print*, 'Valence excitation (eV)  = ', val_exc
          print*, 'RIXS emission energy (eV) = core - valence = ', rixs_em
          print*, 'Emission osc strength (au) = ', fosc
          print*, 'Written: RIXS.out (summary); osc.dat (full osc step log)'
        end subroutine write_rixs_summary

        end program main_rixs
