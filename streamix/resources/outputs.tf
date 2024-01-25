/**
 * Output details of findr eks module
*/
output "streamix_eks_details" {

  /**
   * Description of output
   */
  description = "Cluster details"

  /**
   * Value from findr eks module
   */
  value = module.streamix[*]

}

/**
 * Output details of streamix-s3 module
*/ 
output "streamix_s3_details" {

  /**
   * Description of output
   */
  description = "s3 bucket details"

  /**
   * Value from streamix-edge module
   */
  value = module.streamix-s3[*]

  sensitive = true

}