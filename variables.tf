variable "allow_major_version_upgrade" {
  description = "Habilita upgrades de versões (major) do cluster. Para realizar o upgrade de versão, esta opção deve estar habilitada"
  type        = bool
  default     = false  
}

variable "apply_immediately" {
  description = "Caso true, as alterações que forem realizadas serão aplicadas imediatamente ao invés de esperar pela janela de manutenção. Pode gerar INDISPONIBILIDADE"
  type        = bool
  default     = false 
}
variable "availability_zones" {
  description = "Uma lista de availability zones em que os storages do cluster serão criados. Caso não seja especificada nenhuma, o RDS automaticamente irá atribuir no mínimo 3 zonas. Se for especificado, utilizar ao menos 3 zonas. **MUDAR O VALOR APÓS CRIAÇÃO DO RECURSO FORÇARÁ UMA DESTROY/CREATE!!!**"
  type        = list(string)
  default     = null
}
variable "backtrack_window" {
  description = "Habilita o backtrack na instância sendo o limite de até 72 horas (259200) segundos"
  type        = number
  default     = 3600
}

variable "backup_retention_period" {
  description = "Período de retenção de backup. Valores possíveis entre 1 e 35 (dias)"
  type        = number
  default     = 7       
}

variable "cluster_identifier_prefix" {
  description = "Prefixo do nome que será atribuido ao novo cluster. Conflita com `cluster_identifier`"
  type        = string 
  default     = null     
}

variable "cluster_identifier" {
  description = "Nome que será atribuido ao novo cluster. Conflita com `cluster_identifier_prefix`"
  type        = string 
  default     = null   
}

variable "copy_tags_to_snapshot" {
  description = "Se true, as tags do cluster serão passadas para todos os snapshot"
  type        = bool
  default     = false     
}

variable "database_name" {
  description = "Caso especificado, o nome do database que será criado junto ao cluster"
  type        = string 
  default     = null   
}

variable "deletion_protection" {
  description = "Habilita a proteção de deletar o database"
  type        = bool
  default     = true
}

variable "db_cluster_parameter_group_name" {
  description = "O parameter group que será associado ao cluster"
  type        = string 
  default     = null 
}

variable "parameter_group_family" {
  description = "O parameter group que será associado ao cluster"
  type        = string 
  default     = null
  validation {
    condition     = var.parameter_group_family != null
    error_message = "Please specify the parameter group family (parameter_group_family)." 
  }
}

variable "db_subnet_group_name" {
  description = "O nome do rds subnet group. Caso a opção `create_subnet_group` seja true, criará um novo grupo com este nome"
  type        = string
  default     = null 
}

variable "enable_http_endpoint" {
  description = "Habilita o endpoint http. Só é válido no caso do `engine_mode` configurado como `serverless`"
  type        = bool
  default     = false 
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Lista de logs que serão exportados. aurora-mysql: `slowquery`, `general`, `error`, `audit` / aurora-postgresql: `postgresql`"
  type        = list(string)
  default     = [] 
}

variable "engine_mode" {
  description = "O engine mode do cluster. Valores possíveis: `provisioned`, `multimaster`, `parallelquery` e `serverless`"
  type        = string
  default     = "provisioned"  
}

variable "engine_version" {
  description = "Major version da engine que será utilizada. Caso não seja específicado, será utilizado a versão estável mais recente."
  type        = string
  default     = null
  validation {
    condition     = var.engine_version != null
    error_message = "Please specify the engine version (engine_version)."
  } 
}

variable "engine" {
  description = "O tipo da engine que o cluster utilizará. Possíveis valores. `aurora`, `aurora-mysql` e `aurora-postgresql`"
  type        = string
  default     = "aurora-mysql"
}

variable "final_snapshot_identifier" {
  description = "Nome do snapshot final que será criado quando o cluster for deletado"
  type        = string
  default     = null  
}

variable "global_cluster_identifier" {
  description = "Caso este cluster faça parte de um cluster, global. Especificar o identifier dele"
  type        = string 
  default     = null 
}

variable "iam_database_authentication_enabled" {
  description = "Habilita a autenticação ao cluster usando o IAM da AWS."
  type        = bool 
  default     = false 
}

variable "iam_roles" {
  description = "Uma lista de IAM Roles para atrelar ao cluster no caso de iam_database_authentication_enabled"
  type        = list(string)
  default     = null  
}
variable "kms_key_id" {
  description = "O ARN da chave KMS. Deve ser especificado caso o storage_encrypted seja `true`"
  type        = string 
  default     = null 
}

variable "master_password" {
  description = "Senha do usuário master que será criado na inicialização do cluster. Não é necessário se snapshot_identifier ou replicate_source_db for utilizado."
  type        = string
  default     = null  
}

variable "master_username" {
  description = "Nome do usuário master que será criado na inicialização do cluster. Não é necessário se snapshot_identifier ou replicate_source_db for utilizado."
  type        = string
  default     = null    
}

variable "port" {
  description = "Porta que o banco responde"
  type        = number 
  default     = null
}

variable "preferred_backup_window" {
  description = "Janela de backup do cluster. Valor em UTC e não pode conflitar com a janela de manutenção"
  type        = string
  default     = "05:15-07:00" 
}

variable "preferred_maintenance_window" {
  description = "Janela de manutenção do cluster. Valor em UTC"
  type        = string
  default     = "MON:04:00-MON:05:00" 
}

variable "replication_source_identifier" {
  description = "O ARN ou o DB Instance Identfiier da instância primary, caso esse cluster seja criado como réplica"
  type        = string
  default     = null 
}

variable "skip_final_snapshot" {
  description = "Caso seja true, se o cluster for deletado. Não será realizado um último snapshot."
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Criar o cluster a partir de um snapshot. Aceita tanto o identifier do cluster quanto o ARN de um snaphost"
  type        = string
  default     = null 
}
variable "source_region" {
  description = "A região de origem para uma réplica criptografada do cluster"
  type        = string
  default     = null 
}

variable "storage_encrypted" {
  description = "Caso true, essa opção ira criptografar o storage e seus respectivos snapshots"
  type        = bool 
  default     = false 
}

variable "vpc_security_group_ids" {
  description = "Ids do security group a ser atribuídos aos clusters"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags que será atribuidas aos recursos criados"
  type        = map(string)
  default     = null 
}

variable "restore_pit" {
  description = "Cria o cluster através de um point-in-time restore"
  type        = bool
  default     = false 
}

variable "pit_source_cluster_identifier" {
  description = "Cluster identifier do cluster de origem do snapshot que será realizado o restore point-in-time"
  type        = string
  default     = null 
}

variable "pit_restore_type" {
  description = "Tipo de restore que será realizado. Possíveis valores: `full_copy` e `copy_on_write`"
  type        = string
  default     = "full_copy" 
}

variable "pit_use_latest_restorable_time" {
  description = "Caso true, será realizado o restore do momento mais recente possível. Conflita com `pit_restore_to_time`"
  type        = bool 
  default     = false
}

variable "pit_restore_to_time" {
  description = "Data e hora em UTC. Conflita com `pit_use_latest_restorable_time`. Ex: `2015-03-07T23:45:00Z` (isso é UTC!!!)" 
  type        = string
  default     = null 
}

variable "scaling_configuration_timeout_action" {
  description = "Caso a operação encerre com timeout, qual ação deverá ser acionada. Possíveis valores: `ForceApplyCapacityChange`, `RollbackCapacityChange`"
  type        = string
  default     = "ForceApplyCapacityChange"
}

variable "scaling_configuration_min_capacity" {
  description = "A capacidade mínima em que o cluster pode chegar através do auto scaling. Ver mais na documentação da AWS"
  type        = number
  default     =  2
}

variable "scaling_configuration_max_capacity" {
  description = "A capacidade máxima em que o cluster pode chegar através do auto scaling. Ver mais na documentação da AWS"
  type        = number
  default     =  8
}

variable "scaling_configuration_seconds_until_auto_pause" {
  description = "Tempo que a instância pode permanecer ociosa até ela ser pausada"
  type        = number
  default     = 1800  
}

variable "scaling_configuration_auto_pause" {
  description = "Caso a instância fique idle pelo tempo `seconds_until_auto_pause`. O cluster será parado"
  type        = bool
  default     = true
}

variable "create_timeout" {
  description = "Timeout de criação do cluster. Utilizar a seguinte representação: 1h[m|s]. `h` para hora, `m` para minuto e `s` para segundos."
  type        = string
  default     = "120m"   
}

variable "update_timeout" {
  description = "Timeout de atualização do cluster. Utilizar a seguinte representação: 1h[m|s]. `h` para hora, `m` para minuto e `s` para segundos."
  type        = string
  default     = "120m"   
}

variable "delete_timeout" {
  description = "Timeout de criação do cluster. Utilizar a seguinte representação: 1h[m|s]. `h` para hora, `m` para minuto e `s` para segundos."
  type        = string
  default     = "120m"   
}

variable "security_groups" {
  description = "Lista de security groups ID para registrar nas regras de entrada do SG"
  type        = list(string)
  default     = null
}

variable "parameters" {
  description = "Nome e valores dos parâmetros que serão aplicados no parameter group do cluster"
  type        = list(object({
    name          = string
    value         = string
    apply_method  = string
  }))
  default     = []
}

variable "create_subnet_group" {
  description = "Se true, irá criar um novo DB subnet group"
  type        = bool
  default     = false 
}

variable "subnet_ids" {
  description = "Lista de subnet ids para criação do novo DB subnet group"
  type        = list(string)
  default     = null 
}

variable "writer_endpoint_name" {
  description                               = "DNS que será utilizado pelo endpoint de R/W (Primário)."
  type                                      = string 
  default                                   = null 
}

variable "writer_record_ttl" {
  description                               = "TTL do registro do endpoint de R/W (Primário)"
  type                                      = number
  default                                   = 300 
}

variable "reader_endpoint_name" {
  description = "DNS que será utilizado pelo endpoint de R (Todas as réplicas)."
  type        = string
  default     = null 
}

variable "reader_record_ttl" {
  description = "TTL do registro do endpoint de leitura"
  type        = number
  default     = 300
}

variable "vpc_id" {
  description = "ID da VPC onde os recursos serão criados"
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Id da zona do Route53 que serão criados os registros DNS"
  type        = string
  default     = null
}

variable "cidr_blocks" {
  description = "Lista de Cidr blocks para liberar acesso de entrada ao cluster"
  type        = list(string)
  default     = []
}

variable "create_security_group" {
  description = "Caso true, será criado o security group com acesso de entrada liberada na porta que o cluster responde para a VPC"
  type        = bool
  default     = true
}