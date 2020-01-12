package com.fh.service.impl;

import com.fh.mapper.CityMapper;
import com.fh.model.City;
import com.fh.service.CityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CityServiceImpl implements CityService {

    @Autowired
    private CityMapper cityMapper;

    @Override
    public List<City> queryCityList() {
        return cityMapper.queryCityList();
    }

    @Override
    public void addCity(City city) {
        cityMapper.addCity(city);
    }

    @Override
    public void deleteCity(List<Integer> ids) {
        cityMapper.deleteCity(ids);
    }

    @Override
    public void updateCity(City city) {
        cityMapper.updateCity(city);
    }

    @Override
    public List<City> queryCityListByPid(Integer pid) {
        return cityMapper.queryCityListByPid(pid);
    }
}
