

program test_ncio

    use ncio
    implicit none

    integer, parameter:: ix=96, il=48
    real(4), dimension(ix) :: lon
    real(4), dimension(il) :: lat
    real(4), dimension(ix, il) :: sst
    
    integer k
    character(len=200):: file_name, out_filename
    
    file_name = "/share/kkraid/zhaos/github/iGMAO/data/bc3/t30/clim/sea_surface_temperature.nc"
    call nc_read(file_name, 'sst', sst)
    call nc_read(file_name, 'lat', lat)
    call nc_read(file_name, 'lon', lon)

    
    
    print *, sst
        
    out_filename = "test_1.nc"
    
    ! Create the netcdf file, write global attributes
    call nc_create(out_filename,overwrite=.TRUE.)
    call nc_write_attr(out_filename,"title","test ncio")
    call nc_write_attr(out_filename,"institution", "Universidad Complutense de Madrid; Potsdam Institute for Climate Impact Research")

    ! Write a projection map (not used) centered at [-39E,90N] and no easting or northing offset
    !! call nc_write_map(out_filename,"polar_stereographic",lambda=-39.d0,phi=90.d0,x_e=0.d0,y_n=0.d0) 

    ! Write the dimensions (p, x, y, z, time), defined inline
    call nc_write_dim(out_filename,"lon",  x=lon, units="degree_east", long_name="longitude", axis='X')
    call nc_write_dim(out_filename,"lat",  x=lat, units="degree_north", long_name="latitude", axis='Y')
    call nc_write_dim(out_filename,"time", x=[0.0], units="days since 1980-01-01 00:00:00", calendar="365_day", axis='T', unlimited=.true.)
    call nc_write(out_filename, 'time', (/1, 2, 3/), dims=['time'], count=[3], start=[2])

    call nc_write(out_filename, 'sst', sst, dims=['lon', 'lat', 'time'], count=[ix, il, 1], start=[1, 1, 1], FillValue=9.96921e+36)
    call nc_write(out_filename, 'sst', sst, dims=['lon', 'lat', 'time'], count=[ix, il, 1], start=[1, 1, 2], FillValue=9.96921e+36)
    call nc_write_attr(out_filename, 'sst', 'long_name', 'sea_surface_temperature')
    call nc_write_attr(out_filename, 'sst', 'units', 'K')
          

end program
