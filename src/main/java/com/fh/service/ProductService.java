package com.fh.service;

import com.fh.model.DataTableResult;
import com.fh.model.ProductInfo;
import com.fh.model.ProductQuery;

import java.util.List;

public interface ProductService {

    void addProduct(ProductInfo productInfo);

    DataTableResult queryProductList(ProductQuery productQuery);

    void deleteProduct(Integer id);

    void batchDeleteProduct(List<Integer> idList);

    ProductInfo getProductById(Integer id);

    void updateProduct(ProductInfo productInfo);

}
