select *
from NashvilleHousing

--Standraize sale date 

 
Update NashvilleHousing
set SaleDate = CONVERT (date, SaleDate)


alter table NashvilleHousing
add SaleDateConverted date; 

Update NashvilleHousing
set SaleDateConverted = CONVERT (date, SaleDate)


--Popularty property adress data 

Select  a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing as a
join NashvilleHousing as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]= b.[UniqueID ]
where a.PropertyAddress is null




Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Adress into Individual (Address , City , State) Using Substring + Charindex

select *
from NashvilleHousing
--where a.PropertyAddress is null
--order by ParcelID

select 
substring (PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Adress
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress)) as adress
from NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255) ;

Update NashvilleHousing
SET PropertySplitAddress = substring (PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)

Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255); 


Update NashvilleHousing
SET  PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1 , len(PropertyAddress)) 

Select *
From NashvilleHousing


-- Breaking out  OwnerAddress  into Individual (Address , City , State) Usuing Parsename (It work with Period not commas)

Select 
Parsename (replace(OwnerAddress ,',','.'), 3),
Parsename (replace(OwnerAddress ,',','.'), 2),
Parsename (replace(OwnerAddress ,',','.'), 1)
from NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitAddress = Parsename (replace(OwnerAddress ,',','.'), 3)


Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255); 

Update NashvilleHousing
SET OwnerSplitCity = Parsename (replace(OwnerAddress ,',','.'), 2)

Alter table NashvilleHousing
Add OwnerAddressState nvarchar(255); 

Update NashvilleHousing
SET OwnerAddressState = Parsename (replace(OwnerAddress ,',','.'), 1)


Select *
From NashvilleHousing


-- Change Y and N to Yes and No in the Column ( Sold as Vacant)!!

Select Distinct(SoldAsVacant), count(SoldAsVacant)

from NashvilleHousing
group by SoldAsVacant
order by 2 


Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then ' No'
else SoldAsVacant
end 
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then ' No'
else SoldAsVacant
end 


Select Distinct(SoldAsVacant), count(SoldAsVacant)

from NashvilleHousing
group by SoldAsVacant
order by 2 


--Remove duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate