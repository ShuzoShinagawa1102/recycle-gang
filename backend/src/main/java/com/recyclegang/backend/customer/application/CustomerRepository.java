package com.recyclegang.backend.customer.application;

public interface CustomerRepository {
  CustomerProfile get(String customerId);

  void save(String customerId, CustomerProfile profile);

  void lock(String customerId);
}
