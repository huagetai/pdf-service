package com.paperstreetsoftware.pdfservice;

import static freemarker.template.Configuration.VERSION_2_3_28;
import static freemarker.template.TemplateExceptionHandler.RETHROW_HANDLER;
import static java.util.Locale.US;
import static org.springframework.beans.factory.config.BeanDefinition.SCOPE_PROTOTYPE;
import static org.springframework.beans.factory.config.BeanDefinition.SCOPE_SINGLETON;

import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.Scope;
import org.springframework.core.io.ResourceLoader;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.xhtmlrenderer.pdf.ITextRenderer;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import com.paperstreetsoftware.pdfservice.templating.freemarker.loader.HTTPTemplateLoader;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.core.TemplateDateFormatFactory;
import freemarker.core.TemplateNumberFormatFactory;

@Configuration
@ComponentScan(
	basePackageClasses = { AppConfig.class },
	basePackages = "com.paperstreetsoftware.pdfservice"
)
@PropertySource(
	value = { "classpath:default.pdf.properties" },
	ignoreResourceNotFound = true
)
public class AppConfig implements WebMvcConfigurer {

	@Autowired private HTTPTemplateLoader httpTemplateLoader;
	@Autowired private ResourceLoader resourceLoader;

	@Autowired private TemplateNumberFormatFactory ordinalTemplateNumberFormatFactory;
	@Autowired private TemplateDateFormatFactory ordinalTemplateDateFormatFactory;

	@Value("${pdf.template.path}")
	private String templatePath;

	public static final String DATE_FORMAT = "MM-dd-yyyy";
    public static final String DATE_TIME_FORMAT = "MM-dd-yyyy HH:mm:ss";
    public static final String ASCII2_REGEX = "^[\\x20-\\x7E]+$";
    public static final String ZIP_REGEX = "^\\d{5}(?:[-\\s]\\d{4})?$";

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("index.html");
    }

	@Bean
	@Scope(SCOPE_SINGLETON)
	public freemarker.template.Configuration freeMarkerConfiguration() {
		freemarker.template.Configuration configuration = new freemarker.template.Configuration(VERSION_2_3_28);
		configuration.setDefaultEncoding(StandardCharsets.UTF_8.toString());
		configuration.setLocale(US);
		configuration.setClassLoaderForTemplateLoading(resourceLoader.getClassLoader(), templatePath);
		// configuration.setTemplateLoader(multiTemplateLoader());
		configuration.setTemplateExceptionHandler(RETHROW_HANDLER);
		configuration.setCustomNumberFormats(customNumberFormats());
		configuration.setCustomDateFormats(customDateFormats());
		return configuration;
	}

	@Bean
	@Scope(SCOPE_SINGLETON)
	public ClassTemplateLoader classTemplateLoader() {
		return new ClassTemplateLoader(getClass(), templatePath);
	}

	@Bean
	@Scope(SCOPE_SINGLETON)
	public MultiTemplateLoader multiTemplateLoader() {
		return new MultiTemplateLoader(new TemplateLoader[] { classTemplateLoader(), httpTemplateLoader });
	}

	@Bean
	@Scope(SCOPE_SINGLETON)
	public Map<String, TemplateNumberFormatFactory> customNumberFormats() {
		Map<String, TemplateNumberFormatFactory> customNumberFormats = new HashMap<>();
		customNumberFormats.put("ordinal", ordinalTemplateNumberFormatFactory);
		return customNumberFormats;
	}

	@Bean
	@Scope(SCOPE_SINGLETON)
	public Map<String, TemplateDateFormatFactory> customDateFormats() {
		Map<String, TemplateDateFormatFactory> customDateFormats = new HashMap<>();
		customDateFormats.put("ordinalDate", ordinalTemplateDateFormatFactory);
		return customDateFormats;
	}

	@Bean
	@Scope(SCOPE_PROTOTYPE)
	public ITextRenderer renderer() {
		return new ITextRenderer();
	}

	@Bean
	@Scope(SCOPE_SINGLETON)
	public ObjectMapper objectMapper() {
		ObjectMapper mapper = new ObjectMapper();
		mapper.registerModule(new Jdk8Module());
		mapper.registerModule(new JavaTimeModule());
	    mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
	    mapper.configure(MapperFeature.DEFAULT_VIEW_INCLUSION, true);
	    return mapper;
	}

	@Bean
	@Scope(SCOPE_SINGLETON)
    public Jackson2ObjectMapperBuilderCustomizer jsonCustomizer() {
        return builder -> {
            builder.simpleDateFormat(DATE_TIME_FORMAT);
            builder.serializers(new LocalDateSerializer(DateTimeFormatter.ofPattern(DATE_FORMAT)));
            builder.serializers(new LocalDateTimeSerializer(DateTimeFormatter.ofPattern(DATE_TIME_FORMAT)));
        };
    }

}
