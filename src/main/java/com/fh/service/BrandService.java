package com.fh.service;

import com.fh.model.Brand;
import com.fh.model.BrandQuery;
import com.fh.model.DataTableResult;

import java.util.List;

public interface BrandService {

    //条件查询品牌集合
    DataTableResult queryBrandList(BrandQuery brandQuery);

    //添加品牌
    void addBrand(Brand brand);

    //修改品牌
    void updateBrand(Brand brand);

    //通过Id查询单个品牌用于回显
    Brand getBrandById(Integer id);

    //删除品牌
    void deleteBrand(Integer id);

    //批量删除品牌
    void batchDeleteBrand(List<Integer> idList);

    //批量导入品牌
    void batchAddBrand(List<Brand> brandList);

    List<Brand> queryBrandListNoPage();
}
