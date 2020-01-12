package com.fh.mapper;

import com.fh.model.City;

import java.util.List;

public interface CityMapper {

    List<City> queryCityList();

    void addCity(City city);

    void deleteCity(List<Integer> ids);

    void updateCity(City city);

    List<City> queryCityListByPid(Integer pid);

}
