package com.fh.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fh.model.Brand;

import java.util.List;

public interface BrandMapper extends BaseMapper<Brand> {

    void batchAddBrand(List<Brand> brandList);

}
