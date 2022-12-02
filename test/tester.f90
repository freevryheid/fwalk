program tester

	use,intrinsic::iso_fortran_env,only:error_unit
	use testdrive,only:run_testsuite
	use tests_fwalk_wrapper,only:collect_tests_fwalk_wrapper

	implicit none
	integer::i,stat
	character(len=:),allocatable::test

	test="a"

	do i=1,len(test)
		stat=0
		selectcase(test(i:i))
			case('a')
				print*,new_line('a'),"a. fwalk absolute tests"
				call run_testsuite(collect_tests_fwalk_wrapper,error_unit,stat)
			case default
				error stop "test not defined"
		endselect
		if(stat.gt.0)then
			write(error_unit,'(i0,1x,a)')stat,"test(s) failed!"
			error stop
		endif
	enddo

end program tester
