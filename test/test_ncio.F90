

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
    call nc_write_dim(out_filename,"lon",x=lon,units="degree_east", long_name="longitude")
    call nc_write_dim(out_filename,"lat",x=lat,units="degree_north",long_name="latitude")
    call nc_write_dim(out_filename,"time", x=[0, 1, 2], units="days since 1980-01-01 00:00:00", calendar="365_day", unlimited=.TRUE.)
    call nc_write(out_filename, 'sst', reshape(sst,(/ix, il, 1/)), dims=['lon', 'lat', 'time'], count=[ix, il, 1], start=[1, 1, 1])
    call nc_write(out_filename, 'sst', reshape(sst,(/ix, il, 1/)), dims=['lon', 'lat', 'time'], count=[ix, il, 4], start=[1, 1, 1])

                    

end program
