package com.fh.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fh.mapper.BrandMapper;
import com.fh.model.Brand;
import com.fh.model.BrandQuery;
import com.fh.model.DataTableResult;
import com.fh.service.BrandService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class BrandServiceImpl implements BrandService {

    @Autowired
    private BrandMapper brandMapper;

    @Override
    public DataTableResult queryBrandList(BrandQuery brandQuery) {

        //1.创建查询条件构造器
        QueryWrapper<Brand> queryWrapper = new QueryWrapper<>();
        queryWrapper.like(StringUtils.isNotBlank(brandQuery.getName()),"name",brandQuery.getName())
                .ge(brandQuery.getMinCreateDate()!=null,"createDate",brandQuery.getMinCreateDate())
                .le(brandQuery.getMaxCreateDate()!=null,"createDate",brandQuery.getMaxCreateDate())
                .ge(brandQuery.getMinUpdateDate()!=null,"updateDate",brandQuery.getMinUpdateDate())
                .le(brandQuery.getMaxUpdateDate()!=null,"updateDate",brandQuery.getMaxUpdateDate());

        //2.创建分页查询对象
        Page<Brand> page = new Page<>((brandQuery.getStart()/brandQuery.getLength())+1,brandQuery.getLength());

        //3.进行分页条件查询
        IPage<Brand> brandIPage = brandMapper.selectPage(page,queryWrapper);

        DataTableResult dataTableResult = new DataTableResult(brandQuery.getDraw(),brandIPage.getTotal(),brandIPage.getTotal(),brandIPage.getRecords());

        return dataTableResult;
    }

    @Override
    public void addBrand(Brand brand) {
        brand.setCreateDate(new Date());
        brandMapper.insert(brand);
    }

    @Override
    public void updateBrand(Brand brand) {
        brand.setUpdateDate(new Date());
        brandMapper.updateById(brand);
    }

    @Override
    public Brand getBrandById(Integer id) {
        return brandMapper.selectById(id);
    }

    @Override
    public void deleteBrand(Integer id) {
        brandMapper.deleteById(id);
    }

    @Override
    public void batchDeleteBrand(List<Integer> idList) {
        brandMapper.deleteBatchIds(idList);
    }

    @Override
    public List<Brand> queryBrandListNoPage() {
        return brandMapper.selectList(null);
    }

    @Override
    public void batchAddBrand(List<Brand> brandList) {
        brandMapper.batchAddBrand(brandList);
    }

}
