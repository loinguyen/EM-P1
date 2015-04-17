/**
 * Legend Company
 */
package vn.com.lco.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import vn.com.lco.model.Report;

/**
 * @author OaiPanda
 *
 * ReportRepository.java
 */
public interface ReportRepository extends MongoRepository<Report, String> {

}
