small_zcta %>% 
  st_transform(crs = st_crs(4326)) %>% 
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = labels,
              stroke = FALSE,
              smoothFactor = .5,
              opacity = 1,
              fillOpacity = 0.7,
              fillColor = ~ pal(caserate),
              highlightOptions = highlightOptions(weight = 5,
                                                  fillOpacity = 1,
                                                  color = "black",
                                                  opacity = 1,
                                                  bringToFront = TRUE
              )) %>% 
  addLegend("bottomright",
            pal = pal,
            values = all_modzcta$caserate,
            title = "Cases Per 100,00",
            opacity = 0.7)
