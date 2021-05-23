# TF-AWS-RDS-CLUSTER

Módulo para criação de Aurora RDS Clusters. Este módulo apenas cria o cluster, o motivo de ser feito separadamento das instâncias foi justamente para dar maior controle em relação aos tipos de instância e a quantidade.

Usanso este módulo é possível criar os seguintes recursos:

- RDS Subnet group (opcional)
- Aurora RDS Cluster 
- RDS Cluster Parameter Group (opcional)
- Registro DNS no AWS Route53 para os cluster endpoints de R/W e R.
- Security Group (opcional)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_parameter_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_route53_record.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.reader_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Habilita upgrades de versões (major) do cluster. Para realizar o upgrade de versão, esta opção deve estar habilitada | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Caso true, as alterações que forem realizadas serão aplicadas imediatamente ao invés de esperar pela janela de manutenção. Pode gerar INDISPONIBILIDADE | `bool` | `false` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Uma lista de availability zones em que os storages do cluster serão criados. Caso não seja especificada nenhuma, o RDS automaticamente irá atribuir no mínimo 3 zonas. Se for especificado, utilizar ao menos 3 zonas. **MUDAR O VALOR APÓS CRIAÇÃO DO RECURSO FORÇARÁ UMA DESTROY/CREATE!!!** | `list(string)` | `null` | no |
| <a name="input_backtrack_window"></a> [backtrack\_window](#input\_backtrack\_window) | Habilita o backtrack na instância sendo o limite de até 72 horas (259200) segundos | `number` | `3600` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retenção de backup. Valores possíveis entre 1 e 35 (dias) | `number` | `7` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | Lista de Cidr blocks para liberar acesso de entrada ao cluster | `list(string)` | `[]` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | Nome que será atribuido ao novo cluster. Conflita com `cluster_identifier_prefix` | `string` | `null` | no |
| <a name="input_cluster_identifier_prefix"></a> [cluster\_identifier\_prefix](#input\_cluster\_identifier\_prefix) | Prefixo do nome que será atribuido ao novo cluster. Conflita com `cluster_identifier` | `string` | `null` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Se true, as tags do cluster serão passadas para todos os snapshot | `bool` | `false` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Caso true, será criado o security group com acesso de entrada liberada na porta que o cluster responde para a VPC | `bool` | `true` | no |
| <a name="input_create_subnet_group"></a> [create\_subnet\_group](#input\_create\_subnet\_group) | Se true, irá criar um novo DB subnet group | `bool` | `false` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | Timeout de criação do cluster. Utilizar a seguinte representação: 1h[m\|s]. `h` para hora, `m` para minuto e `s` para segundos. | `string` | `"120m"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Caso especificado, o nome do database que será criado junto ao cluster | `string` | `null` | no |
| <a name="input_db_cluster_parameter_group_name"></a> [db\_cluster\_parameter\_group\_name](#input\_db\_cluster\_parameter\_group\_name) | O parameter group que será associado ao cluster | `string` | `null` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | O nome do rds subnet group. Caso a opção `create_subnet_group` seja true, criará um novo grupo com este nome | `string` | `null` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | Timeout de criação do cluster. Utilizar a seguinte representação: 1h[m\|s]. `h` para hora, `m` para minuto e `s` para segundos. | `string` | `"120m"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Habilita a proteção de deletar o database | `bool` | `true` | no |
| <a name="input_enable_http_endpoint"></a> [enable\_http\_endpoint](#input\_enable\_http\_endpoint) | Habilita o endpoint http. Só é válido no caso do `engine_mode` configurado como `serverless` | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Lista de logs que serão exportados. aurora-mysql: `slowquery`, `general`, `error`, `audit` / aurora-postgresql: `postgresql` | `list(string)` | `[]` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | O tipo da engine que o cluster utilizará. Possíveis valores. `aurora`, `aurora-mysql` e `aurora-postgresql` | `string` | `"aurora-mysql"` | no |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | O engine mode do cluster. Valores possíveis: `provisioned`, `multimaster`, `parallelquery` e `serverless` | `string` | `"provisioned"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Major version da engine que será utilizada. Caso não seja específicado, será utilizado a versão estável mais recente. | `string` | `null` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | Nome do snapshot final que será criado quando o cluster for deletado | `string` | `null` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | Caso este cluster faça parte de um cluster, global. Especificar o identifier dele | `string` | `null` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Habilita a autenticação ao cluster usando o IAM da AWS. | `bool` | `false` | no |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | Uma lista de IAM Roles para atrelar ao cluster no caso de iam\_database\_authentication\_enabled | `list(string)` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | O ARN da chave KMS. Deve ser especificado caso o storage\_encrypted seja `true` | `string` | `null` | no |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | Senha do usuário master que será criado na inicialização do cluster. Não é necessário se snapshot\_identifier ou replicate\_source\_db for utilizado. | `string` | `null` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Nome do usuário master que será criado na inicialização do cluster. Não é necessário se snapshot\_identifier ou replicate\_source\_db for utilizado. | `string` | `null` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | O parameter group que será associado ao cluster | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Nome e valores dos parâmetros que serão aplicados no parameter group do cluster | <pre>list(object({<br>    name          = string<br>    value         = string<br>    apply_method  = string<br>  }))</pre> | `[]` | no |
| <a name="input_pit_restore_to_time"></a> [pit\_restore\_to\_time](#input\_pit\_restore\_to\_time) | Data e hora em UTC. Conflita com `pit_use_latest_restorable_time`. Ex: `2015-03-07T23:45:00Z` (isso é UTC!!!) | `string` | `null` | no |
| <a name="input_pit_restore_type"></a> [pit\_restore\_type](#input\_pit\_restore\_type) | Tipo de restore que será realizado. Possíveis valores: `full_copy` e `copy_on_write` | `string` | `"full_copy"` | no |
| <a name="input_pit_source_cluster_identifier"></a> [pit\_source\_cluster\_identifier](#input\_pit\_source\_cluster\_identifier) | Cluster identifier do cluster de origem do snapshot que será realizado o restore point-in-time | `string` | `null` | no |
| <a name="input_pit_use_latest_restorable_time"></a> [pit\_use\_latest\_restorable\_time](#input\_pit\_use\_latest\_restorable\_time) | Caso true, será realizado o restore do momento mais recente possível. Conflita com `pit_restore_to_time` | `bool` | `false` | no |
| <a name="input_port"></a> [port](#input\_port) | Porta que o banco responde | `number` | `null` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | Janela de backup do cluster. Valor em UTC e não pode conflitar com a janela de manutenção | `string` | `"05:15-07:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | Janela de manutenção do cluster. Valor em UTC | `string` | `"MON:04:00-MON:05:00"` | no |
| <a name="input_reader_endpoint_name"></a> [reader\_endpoint\_name](#input\_reader\_endpoint\_name) | DNS que será utilizado pelo endpoint de R (Todas as réplicas). | `string` | `null` | no |
| <a name="input_reader_record_ttl"></a> [reader\_record\_ttl](#input\_reader\_record\_ttl) | TTL do registro do endpoint de leitura | `number` | `300` | no |
| <a name="input_replication_source_identifier"></a> [replication\_source\_identifier](#input\_replication\_source\_identifier) | O ARN ou o DB Instance Identfiier da instância primary, caso esse cluster seja criado como réplica | `string` | `null` | no |
| <a name="input_restore_pit"></a> [restore\_pit](#input\_restore\_pit) | Cria o cluster através de um point-in-time restore | `bool` | `false` | no |
| <a name="input_scaling_configuration_auto_pause"></a> [scaling\_configuration\_auto\_pause](#input\_scaling\_configuration\_auto\_pause) | Caso a instância fique idle pelo tempo `seconds_until_auto_pause`. O cluster será parado | `bool` | `true` | no |
| <a name="input_scaling_configuration_max_capacity"></a> [scaling\_configuration\_max\_capacity](#input\_scaling\_configuration\_max\_capacity) | A capacidade máxima em que o cluster pode chegar através do auto scaling. Ver mais na documentação da AWS | `number` | `8` | no |
| <a name="input_scaling_configuration_min_capacity"></a> [scaling\_configuration\_min\_capacity](#input\_scaling\_configuration\_min\_capacity) | A capacidade mínima em que o cluster pode chegar através do auto scaling. Ver mais na documentação da AWS | `number` | `2` | no |
| <a name="input_scaling_configuration_seconds_until_auto_pause"></a> [scaling\_configuration\_seconds\_until\_auto\_pause](#input\_scaling\_configuration\_seconds\_until\_auto\_pause) | Tempo que a instância pode permanecer ociosa até ela ser pausada | `number` | `1800` | no |
| <a name="input_scaling_configuration_timeout_action"></a> [scaling\_configuration\_timeout\_action](#input\_scaling\_configuration\_timeout\_action) | Caso a operação encerre com timeout, qual ação deverá ser acionada. Possíveis valores: `ForceApplyCapacityChange`, `RollbackCapacityChange` | `string` | `"ForceApplyCapacityChange"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Lista de security groups ID para registrar nas regras de entrada do SG | `list(string)` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Caso seja true, se o cluster for deletado. Não será realizado um último snapshot. | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Criar o cluster a partir de um snapshot. Aceita tanto o identifier do cluster quanto o ARN de um snaphost | `string` | `null` | no |
| <a name="input_source_region"></a> [source\_region](#input\_source\_region) | A região de origem para uma réplica criptografada do cluster | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Caso true, essa opção ira criptografar o storage e seus respectivos snapshots | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Lista de subnet ids para criação do novo DB subnet group | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags que será atribuidas aos recursos criados | `map(string)` | `null` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | Timeout de atualização do cluster. Utilizar a seguinte representação: 1h[m\|s]. `h` para hora, `m` para minuto e `s` para segundos. | `string` | `"120m"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC onde os recursos serão criados | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Ids do security group a ser atribuídos aos clusters | `list(string)` | `null` | no |
| <a name="input_writer_endpoint_name"></a> [writer\_endpoint\_name](#input\_writer\_endpoint\_name) | DNS que será utilizado pelo endpoint de R/W (Primário). | `string` | `null` | no |
| <a name="input_writer_record_ttl"></a> [writer\_record\_ttl](#input\_writer\_record\_ttl) | TTL do registro do endpoint de R/W (Primário) | `number` | `300` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Id da zona do Route53 que serão criados os registros DNS | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_identifier"></a> [cluster\_identifier](#output\_cluster\_identifier) | n/a |
| <a name="output_db_cluster_parameter_group_name"></a> [db\_cluster\_parameter\_group\_name](#output\_db\_cluster\_parameter\_group\_name) | n/a |
| <a name="output_db_subnet_group_name"></a> [db\_subnet\_group\_name](#output\_db\_subnet\_group\_name) | n/a |
| <a name="output_engine"></a> [engine](#output\_engine) | n/a |
| <a name="output_engine_version"></a> [engine\_version](#output\_engine\_version) | n/a |
| <a name="output_preferred_backup_window"></a> [preferred\_backup\_window](#output\_preferred\_backup\_window) | n/a |
| <a name="output_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#output\_preferred\_maintenance\_window) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |
