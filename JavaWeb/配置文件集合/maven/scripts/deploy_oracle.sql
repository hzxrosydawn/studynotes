DROP TABLE TB_OPT_LOG;

-- 创建操作日志表
CREATE TABLE TB_OPT_LOG
(
  logic_id      NUMBER(10) PRIMARY KEY NOT NULL,
  source_end    VARCHAR2(20)             NOT NULL,
  opt_type      VARCHAR2(30)             NOT NULL,
  start_time    DATE                     NOT NULL,
  source_entity VARCHAR2(4000),
  opt_end       VARCHAR2(20)             NOT NULL,
  done_code     VARCHAR2(200),
  done_msg      VARCHAR2(500),
  done_entity   VARCHAR2(4000),
  done_time     DATE,
  done_result   VARCHAR2(10)             NOT NULL,
  done_desc     VARCHAR2(500)            NOT NULL,
  local_host    VARCHAR2(50)             NOT NULL,
  create_time   DATE                     NOT NULL
);

-- 添加注释
COMMENT ON TABLE TB_OPT_LOG IS '操作日志表';
COMMENT ON COLUMN TB_OPT_LOG.logic_id IS '操作记录的逻辑id、主键，不会重复';
COMMENT ON COLUMN TB_OPT_LOG.source_end IS '操作信息的来源系统标识';
COMMENT ON COLUMN TB_OPT_LOG.opt_type IS '操作类型';
COMMENT ON COLUMN TB_OPT_LOG.start_time IS '操作开始时间';
COMMENT ON COLUMN TB_OPT_LOG.source_entity IS '操作的信息内容';
COMMENT ON COLUMN TB_OPT_LOG.opt_end IS '操作执行端标识';
COMMENT ON COLUMN TB_OPT_LOG.done_code IS '操作完成的结果码';
COMMENT ON COLUMN TB_OPT_LOG.done_msg IS '操作完的消息描述';
COMMENT ON COLUMN TB_OPT_LOG.done_entity IS '操作完成时间';
COMMENT ON COLUMN TB_OPT_LOG.done_result IS '操作结果。success或fail';
COMMENT ON COLUMN TB_OPT_LOG.done_desc IS '操作结果的简短描述';
COMMENT ON COLUMN TB_OPT_LOG.local_host IS ' 操作执行的本地服务器IP';
COMMENT ON COLUMN TB_OPT_LOG.create_time IS '操作记录入库时间';
--- 添加索引
CREATE INDEX IDX_TB_O_LOG_SOR_END
  ON TB_OPT_LOG (source_end);
CREATE INDEX IDX_TB_O_LOG_OPT_TYPE
  ON TB_OPT_LOG (opt_type);
CREATE INDEX IDX_TB_O_LOG_STR_TIME
  ON TB_OPT_LOG (start_time);
CREATE INDEX IDX_TB_O_LOG_OPT_END
  ON TB_OPT_LOG (opt_end);
CREATE INDEX IDX_TB_O_LOG_DONE_CODE
  ON TB_OPT_LOG (done_code);
CREATE INDEX IDX_TB_O_LOG_DONE_RESULT
  ON TB_OPT_LOG (done_result);
CREATE INDEX IDX_TB_O_LOG_LOC_HOST
  ON TB_OPT_LOG (local_host);
CREATE INDEX IDX_TB_O_LOG_CRE_TIME
  ON TB_OPT_LOG (create_time);

---创建序列值
CREATE SEQUENCE SEQ_OPT_LOG
MINVALUE 1
MAXVALUE 99999999999999999999
START WITH 1
INCREMENT BY 1
CACHE 100;