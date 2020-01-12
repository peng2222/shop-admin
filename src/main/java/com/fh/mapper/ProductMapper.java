package com.fh.mapper;

import com.fh.model.Product;
import com.fh.model.ProductQuery;

import java.util.List;

public interface ProductMapper {

    void addProduct(Product product);

    Long queryProductCount(ProductQuery productQuery);

    List<Product> queryProductList(ProductQuery productQuery);

    void deleteProduct(Integer id);

    void batchDeleteProduct(List<Integer> idList);

    Product getProductById(Integer id);

    void updateProduct(Product product);
}
