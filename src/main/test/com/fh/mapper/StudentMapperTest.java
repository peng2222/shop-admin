package com.fh.mapper;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.metadata.TableFieldInfo;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fh.model.Student;
import org.apache.commons.lang3.StringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.function.Function;
import java.util.function.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext.xml"})
public class StudentMapperTest {

    @Autowired
    private StudentDao studentDao;

    //添加学生信息
    @Test
    public void testInsertStudent(){
        Student student = new Student();
        student.setName("张旭浩3");
        student.setAge(38);
        student.setSex(1);
        student.setEmail("110.@163.com");
        student.setPhone("123456789");
        student.setWeight(120.22);
        student.setBirthday(new Date());
        student.setAreaName("菲律宾");
        student.setClassName("1912A");
        student.setCreateDate(new Date());
        student.setUpdateDate(new Date());
        int count = studentDao.insert(student);
        System.out.println("受影响的行数：" + count);
    }

    //查询学生表信息
    @Test
    public void testSelectList(){
        List<Student> studentList = studentDao.selectList(null);
        for(Student student : studentList){
            System.out.println(student);
        }
    }

    //通过主键id进行查询
    @Test
    public void testSelectById(){
        Student student = studentDao.selectById(2);
        System.out.println(student);
    }

    //通过主键id集合进行查询
    @Test
    public void testSelectBatchIds(){
        List<Student> studentList = studentDao.selectBatchIds(Arrays.asList(2, 3));
        for(Student student : studentList){
            System.out.println(student);
        }
    }

    //通过Map进行查询
    @Test
    public void testSelectByMap(){
        //注意Map中的键是数据库表中的字段名
        Map<String,Object> sssMap = new LinkedHashMap<>();
        sssMap.put("name","张旭浩1");
        sssMap.put("age",38);
        List<Student> studentList = studentDao.selectByMap(sssMap);
        for (Student student : studentList){
            System.out.println(student);
        }
    }


    //需求1:查询学生名称包含"张旭浩"并且为1912A班的学生
    @Test
    public void testSelectByWrapper(){
        //创建条件构造器的两种方式
        QueryWrapper<Student> queryWrapper = new QueryWrapper<>();
        //第二种
        //QueryWrapper<Student> queryWrapper = Wrappers.<Student>query();
        queryWrapper.like("name","张旭浩").eq("className","1912A");
        List<Student> studentList = studentDao.selectList(queryWrapper);
        /*for(Student student : studentList){
            System.out.println(student);
        }*/
        studentList.forEach(x-> System.out.println(x));
    }


    //需求2:查询学生名称包含"张旭浩"并且年龄在20到40之间的且手机号不为空的学生信息
    @Test
    public void testSelectByWrapper2(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("name","张旭浩")
                .between("age",20,40)
                .isNotNull("phone");
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //需求3:查询学生名称以"张旭浩"开头的或者年龄大于38的学生信息，要求以年龄进行降序排列，如果年龄一样则以id升序排列。
    @Test
    public void testSelectByWrapper3(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<>();
        queryWrapper.likeRight("name","张")
                .gt("age",38)
                .orderByDesc("age")
                .orderByAsc("id");
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //需求4:查询生日为2019-12-1号并且地区为菲律宾的学生
    @Test
    public void testSelectByWrapper4(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<>();
        queryWrapper.apply("date_format(birthday,'%y-%m-%d')","2019-12-1")
                .inSql("areaName","select id from t_student where areaName = '菲律宾'");
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //需求5:查询以"张"开头的并且(年龄小于30或者地区不为空)的学生信息。
    @Test
    public void testSelectByWrapper5(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>();
        queryWrapper.likeRight("name","张").and(new Function<QueryWrapper<Student>, QueryWrapper<Student>>() {
            @Override
            public QueryWrapper<Student> apply(QueryWrapper<Student> studentQueryWrapper) {
                return studentQueryWrapper.lt("age",30).or().isNotNull("areaName");
            }
        });
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //需求6:查询(年龄小于30或者地区不为空)并且以"张"开头的的学生信息。
    @Test
    public void testSelectByWrapper6(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>();
        queryWrapper.nested(new Function<QueryWrapper<Student>, QueryWrapper<Student>>() {
            @Override
            public QueryWrapper<Student> apply(QueryWrapper<Student> studentQueryWrapper) {
                return studentQueryWrapper.lt("age",30).or().isNotNull("areaName");
            }
        }).likeRight("name","张");
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //需求7:查询叙利亚，菲律宾，越南的学生信息。、
    @Test
    public void testSelectByWrapper7(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>();
        queryWrapper.in("areaName",Arrays.asList("菲律宾","叙利亚","越南"));
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //需求8:返回满足条件的第一条数据
    @Test
    public void testSelectByWrapper8(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>();
        queryWrapper.in("areaName",Arrays.asList("菲律宾","叙利亚","越南")).last("limit 1");
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //需求9:查询指定的字段
    @Test
    public void testSelectByWrapper9(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>();
        queryWrapper.select(Student.class,new Predicate<TableFieldInfo>() {
            @Override
            public boolean test(TableFieldInfo aaa) {
                return !aaa.getColumn().equals("className") && !aaa.getColumn().equals("areaName");
            }
        });
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //Condition的作用
    @Test
    public void testSelectByWrapper10(){
        String name = "";
        String email = "123";
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>();
        queryWrapper.like(StringUtils.isNotBlank(name),"name",name)
                .like(StringUtils.isNotBlank(email),"email",email);
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //实体作为条件构造方法的参数
    @Test
    public void testSelectByWrapper11(){
        Student student = new Student();
        student.setName("张");
        student.setAreaName("叙利亚");
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>(student);
        List<Student> studentList = studentDao.selectList(queryWrapper);
        studentList.forEach(x-> System.out.println(x));
    }


    //自定义SQL
    @Test
    public void testSelectByWrapper12(){
        List<Student> studentList = studentDao.queryAll();
        studentList.forEach(x-> System.out.println(x));
    }


    //分页查询
    @Test
    public void testSelectByWrapper13(){
        QueryWrapper<Student> queryWrapper = new QueryWrapper<Student>();
        queryWrapper.like("name","张");
        //第一个参数代表当前页数，第二个参数代表每页显示条数
        Page<Student> page = new Page<>(1,2,true);
        IPage<Student> studentIPage = studentDao.selectPage(page, queryWrapper);
        studentIPage.getRecords().forEach(x-> System.out.println(x));
    }


    //使用MP进行修改操作
    @Test
    public void testSelectByWrapper14(){
        //1.通过主键id进行修改
        Student student = new Student();
        student.setId(1);
        student.setAreaName("中国");
        studentDao.updateById(student);

        Student student2 = studentDao.selectById(2);
        student2.setName("李嘉欣");
        studentDao.updateById(student2);

        //2.根据条件进行修改
        //创建一个修改条件构造器
        //第一种方式
        UpdateWrapper<Student> updateWrapper = new UpdateWrapper<>();
        //第二种方式
        //UpdateWrapper<Student> update = Wrappers.update();
        updateWrapper.like("name","张");
        Student student3 = new Student();
        student3.setAreaName("日本");
        student3.setClassName("1912");
        studentDao.update(student3,updateWrapper);
    }

    //MP的AR模式
    @Test
    public void testSelectByWrapper15(){
        Student student = new Student();
        List<Student> studentList = student.selectAll();
        studentList.forEach(x-> System.out.println(x));

        student.setName("旭浩冲吧");
        student.setClassName("1905A");
        student.setAreaName("偃师");
        student.insert();

        student.setId(4);
        student.updateById();
    }
}
